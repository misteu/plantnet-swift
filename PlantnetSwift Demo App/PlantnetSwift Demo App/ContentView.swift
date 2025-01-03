//
//  ContentView.swift
//  PlantnetSwift Demo App
//
//  Created by Michael Steudter on 03.01.25.
//

import SwiftUI

struct ContentView: View {

	@State var results: [String] = []

    var body: some View {
        VStack {
			Text("Tap image to start")
				.font(.largeTitle)
			Group {
				PlantImageButton(image: UIImage(resource: .TestImages.anthurium), results: $results)
				PlantImageButton(image: UIImage(resource: .TestImages.lotus), results: $results)
				PlantImageButton(image: UIImage(resource: .TestImages.rose), results: $results)
			}
			.frame(height: 100)
			ScrollView {
				VStack {
					ForEach(results, id: \.self) { result in
						Text(LocalizedStringKey(result))
							.font(.caption)
							.fixedSize(horizontal: false, vertical: true)
							.frame(maxWidth: .infinity, alignment: .leading)
							.padding(8)
						
					}
				}
			}
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
