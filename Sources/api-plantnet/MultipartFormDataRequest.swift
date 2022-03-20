//
//  MultipartFormDataRequest.swift
//  
//
//  Based on:
// https://codecrew.codewithchris.com/t/does-anybody-know-how-to-upload-an-image-using-multipart-form-data-post-method/14800/3

import UIKit

enum MultipartFormDataRequest {

	static func createDataBody(withParameters params: [String: String]?, media: [Media]?, boundary: String) -> Data {

		let lineBreak = "\r\n"
		var body = Data()

		if let parameters = params {
			for (key, value) in parameters {
				body.append("--\(boundary + lineBreak)")
				body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
				body.append("\(value + lineBreak)")
			}
		}

		if let media = media {
			for photo in media {
				body.append("--\(boundary + lineBreak)")
				body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.fileName)\"\(lineBreak)")
				body.append("Content-Type: \(photo.mimeType + lineBreak + lineBreak)")
				body.append(photo.data)
				body.append(lineBreak)
			}
		}

		body.append("--\(boundary)--\(lineBreak)")

		return body
	}


	struct Media {
		let key: String
		let fileName: String
		let data: Data
		let mimeType: String

		init?(withImage image: UIImage, forKey key: String) {
			self.key = key
			self.mimeType = "image/jpg"
			self.fileName = "\(arc4random()).jpeg"

			guard let data = image.jpegData(compressionQuality: 0.3) else { return nil }
			self.data = data
		}
	}
}

extension Data {
	mutating func append(_ string: String) {
		if let data = string.data(using: .utf8) {
			append(data)
		}
	}
}
