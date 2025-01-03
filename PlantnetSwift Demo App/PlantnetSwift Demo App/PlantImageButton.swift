//
//  PlantImageButton.swift
//  PlantnetSwift Demo App
//
//  Created by Michael Steudter on 03.01.25.
//

import SwiftUI
import api_plantnet

struct PlantImageButton: View {

	let image: UIImage

	@Binding var results: [String]
	@State var isLoading: Bool = false

    var body: some View {
		Button {
			Task {
				isLoading = true
				do {
					results = try await PlantNetService.identificationsWithScore(for: image)
				} catch let error as PlantNetError {
					print(error)
					if error.statusCode == 401 {
						results = ["\(error)" + "\n\nCheck your API Key, see https://my.plantnet.org/doc for instructions on how to get one"]
					}
				}
				isLoading = false
			}
		} label: {
			if isLoading {
				ProgressView()
			} else {
				Image(uiImage: image)
					.resizable()
					.aspectRatio(contentMode: .fit)
			}
		}
		.clipShape(.capsule)
    }
}
