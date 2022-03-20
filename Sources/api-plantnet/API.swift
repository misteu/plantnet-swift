//
//  API.swift
//  
//
//  Created by skrr on 04.03.22.
//

import UIKit

public enum PlantNet {

	public struct APIKey {
		static var shared: APIKey? = nil
		let key: String

		public static func configure(with key: String) {
			shared = APIKey(key: key)
		}
	}

	static let session = URLSession.shared

	/// Gets full list of species (Pretty large list, approx. 6MB)
	case getListOfSpecies
	/// Gets list of projects (e.g. `Weeds`, `Useful Plants`, etc.) can be set on identify request to narrow down source of results.
	case getListOfProjects
	/// Post image as jpeg mime type data.
	/// Language code (e.g. de or en) to set language of returned identifications. Defaults to `en` when `nil`
	case postIdentify(image: UIImage, languageCode: String?)

	var endpoint: URL {
		var retVal = URL(string: "https://www.google.com")!
		if let apiKey = APIKey.shared?.key {
			switch self {
			case .getListOfSpecies:
				retVal = URL(string: "https://my-api.plantnet.org/v2/species?api-key=\(apiKey)")!
			case .getListOfProjects:
				retVal = URL(string: "https://my-api.plantnet.org/v2/projects?api-key=\(apiKey)")!
			case .postIdentify(_, languageCode: let code):
				if let code = code {
					retVal = URL(string: "https://my-api.plantnet.org/v2/identify/all?api-key=\(apiKey)&lang=\(code)")!
				} else {
					retVal = URL(string: "https://my-api.plantnet.org/v2/identify/all?api-key=\(apiKey)")!
				}
			}
		}
		return retVal
	}

	var method: String {
		switch self {
		case .getListOfProjects, .getListOfSpecies:
			return "GET"
		case .postIdentify:
			return "POST"
		}
	}

	var request: URLRequest {
		var request = URLRequest(url: endpoint)
		switch self {
		case .getListOfProjects, .getListOfSpecies:
			request.httpMethod = method
		case .postIdentify(image: let image, _):
			request = imageUploadRequest(image: image)
		}
		return request
	}

	func imageUploadRequest(image: UIImage) -> URLRequest {

		let boundary = "Boundary-\(NSUUID().uuidString)"
		var request = URLRequest(url: endpoint)

		guard let mediaImage = MultipartFormDataRequest.Media(withImage: image, forKey: "images") else { return request }

		request.httpMethod = method

		request.allHTTPHeaderFields = [
			"X-User-Agent": "ios",
			"Accept-Language": "en",
			"Accept": "application/json",
			"Content-Type": "multipart/form-data; boundary=\(boundary)"
		]

		let dataBody = MultipartFormDataRequest.createDataBody(
			withParameters: nil,
			media: [mediaImage],
			boundary: boundary
		)
		request.httpBody = dataBody
		return request
	}

	public func request<DTO: Codable>(responseType: DTO.Type = DTO.self, completionHandler: @escaping (Result<DTO, Error>?) -> Void) {
		codableTask(responseType: responseType,
					completionHandler: completionHandler)
			.resume()
	}

	static func newJSONDecoder() -> JSONDecoder {
		let decoder = JSONDecoder()
		if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
			decoder.dateDecodingStrategy = .iso8601
		}
		return decoder
	}

	fileprivate func codableTask<DTO: Codable>(responseType: DTO.Type? = DTO.self, completionHandler: @escaping (Result<DTO, Error>?) -> Void) -> URLSessionDataTask {
		return Self.session.dataTask(with: request as URLRequest) { data, response, error in
			guard let data = data,
				  error == nil,
				  let responseType = responseType
			else {
				completionHandler(.failure(error ?? NSError(domain: "unknown url session error",
															code: 0,
															userInfo: nil )))
				return
			}
			if let result = try? Self.newJSONDecoder().decode(responseType, from: data) {
				completionHandler(.success(result))
			} else if let plainTextResult = String(data: data, encoding: .utf8) {
				// If there is only plain text in the response, we expect it to be an error.
				completionHandler(.failure(NSError(domain: plainTextResult,
												   code: 0,
												   userInfo: nil )))
			}
		}
	}
}
