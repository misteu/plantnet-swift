//
//  PlantNetService.swift
//  PlantnetSwift Demo App
//
//  Created by Michael Steudter on 03.01.25.
//

import Foundation
import UIKit
import api_plantnet
import SwiftUICore

struct PlantNetService {

	static let percentageFormatter: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.numberStyle = .percent
		formatter.maximumFractionDigits = 0
		return formatter
	}()

	static func identificationsWithScore(for image: UIImage) async throws -> [String] {
		try await withCheckedThrowingContinuation { continuation in
			PlantNet.postIdentify(image: image, languageCode: "de").request(responseType: IdentificationDTO.self) { result in
				if let result = result {
					switch result {
						case .success(let dto):
						let results = dto
								.results
								.enumerated()
								.filter({ $0.offset < 10 })
								.map {
									let percentage = percentageFormatter.string(from: $0.element.score as NSNumber) ?? ""
									return "\($0.element.species.scientificName) *\(percentage)*"
								}
						continuation.resume(returning: results)
						case .failure(let error):
						continuation.resume(throwing: error)
					}
				}
			}
		}
	}
}
