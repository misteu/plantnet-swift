//
//  ProjectsDTO.swift
//  
//
//  Created by skrr on 04.03.22.
//

import Foundation

// MARK: - ProjectsDTOElement
public struct ProjectsDTOElement: Codable {
	public let id, title, projectsDTODescription: String

	enum CodingKeys: String, CodingKey {
		case id, title
		case projectsDTODescription = "description"
	}
}
