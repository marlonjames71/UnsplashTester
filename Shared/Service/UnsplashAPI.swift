//
//  UnsplashAPI.swift
//  iOS
//
//  Created by Marlon Raskin on 7/19/20.
//

import SwiftUI
import Combine

class UnsplashAPIService: ObservableObject {

	@Published var result: UnsplashResult?

	private var cancellationToken: AnyCancellable?

	let baseURL: URL
	let decoder: JSONDecoder


	// MARK: - INIT
	init() {
		baseURL = URL(string: "https://api.unsplash.com/photos/")!
		self.decoder = JSONDecoder()
	}

	deinit {
		cancel()
	}

	func cancel() {
		cancellationToken?.cancel()
	}


	// MARK: - Functions
	func fetch(_ path: Path) {
		cancel()
		do {
			let url = try urlBuilder(path: path)
			cancellationToken = URLSession.shared.dataTaskPublisher(for: url)
				.tryMap { result in
					return try self.decoder.decode(UnsplashResult.self, from: result.data)
				}
				.replaceError(with: nil)
				.receive(on: DispatchQueue.main)
				.assign(to: \.result, on: self)
		} catch {
			NSLog("Error building URL from: \(path) argument: \(error)")
		}
	}


	// MARK: - URL Builder
	enum UnsplashError: Error {
		case invalidURL
	}

	enum Path {
		case random
		case search(query: String)
	}

	private func urlBuilder(path: Path) throws -> URL {
		var url = baseURL
		let queryItems: [URLQueryItem]
		switch path {
		case .random:
			url.appendPathComponent("random")

			queryItems = [
				URLQueryItem(name: "client_id", value: .accessKey),
				URLQueryItem(name: "orientation", value: "landscape"),
				URLQueryItem(name: "featured", value: nil)
			]
		case .search(query: let query):
			url.appendPathComponent("search")

			queryItems = [
				URLQueryItem(name: "client_id", value: .accessKey),
				URLQueryItem(name: "query", value: query),
				URLQueryItem(name: "orientation", value: "landscape"),
				URLQueryItem(name: "count", value: "30")
			]
		}

		guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else { throw UnsplashError.invalidURL }
		components.queryItems = queryItems
		guard let finalUrl = components.url else { throw UnsplashError.invalidURL }
		print(finalUrl)
		return finalUrl
	}
}
