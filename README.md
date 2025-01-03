# api-plantnet

Unofficial Swift Package for communicating with Pl@ntNet API.

To get access to the API you need an API key. See [https://my-api.plantnet.org/?tags=my-api] for API docs and setting up access in general.

## Quickstart

There is a demo app written in SwiftUI inside of this repo. Clonse the repo, build and run project inside of [https://github.com/misteu/plantnet-swift/tree/main/PlantnetSwift%20Demo%20App].

Only thing to do is insert your API key inside of `PlantnetSwift_Demo_AppApp.swift`.

## Setup the package

Before being able to call the endpoints you need to configure the package with your API key via:

```swift
PlantNet.APIKey.configure("YOUR_API_KEY")
```

## Endpoints

Currently, not all endpoints (as specified here: [https://my.plantnet.org/account/doc#openapi]) are supported. Also the decoded data might be limited.

The currently supported endpoints are: `POST /v2/identify/{project}`,  `GET /v2/species` and `GET /v2/projects`

If you need more of the endpoints or anything else, please open an issue.

### Plant Identification

Example: Post a `UIImage` via multipart form request for plant identification. `languageCode` is optional, `"en"` is the default if nothing is passed.

```swift
PlantNet.postIdentify(image: image, languageCode: "de").request(responseType: IdentificationDTO.self) { result in
	if let result = result {
		switch result {
			case .success(let dto):
				let identifications = dto
					.results
					.enumerated()
					.filter({ $0.offset < 10 })
					.map { "\($0.element.species.scientificName) \($0.element.score)" }.joined(separator: "\n")
				print("First ten identifications:\n\(identifications)")
			case .failure(let error):
				print(error)
		}
	}
}

```