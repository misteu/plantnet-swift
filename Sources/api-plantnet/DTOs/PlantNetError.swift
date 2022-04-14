//
//  PlantNetError.swift
//  GardenApp
//
//  Created by skrr on 14.04.22.
//  Copyright © 2022 mic. All rights reserved.
//

import Foundation

// MARK: - PlantNetError
public struct PlantNetError: Codable, Error {
	public let statusCode: Int
	public let error, message: String
}
