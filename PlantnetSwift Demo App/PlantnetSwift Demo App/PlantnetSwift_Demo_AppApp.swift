//
//  PlantnetSwift_Demo_AppApp.swift
//  PlantnetSwift Demo App
//
//  Created by Michael Steudter on 03.01.25.
//

import SwiftUI
import api_plantnet

@main
struct PlantnetSwift_Demo_AppApp: App {

	init() {
		// Register to PlantNet API
		PlantNet.APIKey.configure(with: "INSERT YOUR API KEY")
	}

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
