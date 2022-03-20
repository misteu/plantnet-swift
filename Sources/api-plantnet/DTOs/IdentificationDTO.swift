//
//  File.swift
//  
//
//  Created by skrr on 04.03.22.
//

import Foundation

// MARK: - IdentificationDTO
public struct IdentificationDTO: Codable {
	let query: Query
	let language, preferedReferential, bestMatch: String
	public let results: [IdentificationResult]
	let version: String
	let remainingIdentificationRequests: Int
}

// MARK: - Query
struct Query: Codable {
	let project: String
	let images, organs: [String]
	let includeRelatedImages: Bool
}

// MARK: - Result
public struct IdentificationResult: Codable {
	public let score: Double
	public let species: Species
	let gbif: Gbif?
}

// MARK: - Gbif
struct Gbif: Codable {
	let id: String
}

// MARK: - Species
public struct Species: Codable {
	public let scientificNameWithoutAuthor, scientificNameAuthorship: String
	public let genus, family: Family
	public let commonNames: [String]
	public let scientificName: String
}

// MARK: - Family
public struct Family: Codable {
	public let scientificNameWithoutAuthor, scientificNameAuthorship, scientificName: String
}
