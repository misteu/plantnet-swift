//
//  File.swift
//  
//
//  Created by skrr on 04.03.22.
//

import Foundation

// MARK: - SpeciesDTOElement
public struct SpeciesDTOElement: Codable {
	let id, scientificNameWithoutAuthor, scientificNameAuthorship: String
	let gbifID: Int

	enum CodingKeys: String, CodingKey {
		case id, scientificNameWithoutAuthor, scientificNameAuthorship
		case gbifID = "gbifId"
	}
}
