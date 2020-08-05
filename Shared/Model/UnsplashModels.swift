//
//  UnsplashModels.swift
//  iOS
//
//  Created by Marlon Raskin on 7/19/20.
//

import Foundation


struct UnsplashResult: Decodable {
	var id: String
	let urls: UnsplashURL
	let user: UnsplashUser
}

struct UnsplashURL: Decodable {
	let regular: URL
}

struct UnsplashUser: Decodable {
	let name: String?
	let first_name: String?
	let last_name: String?
	let links: UnsplashUserPhotoLinks

	var presentationName: String {
		let fullname = [first_name, last_name].compactMap { $0 }.joined(separator: " ")
		return fullname.isEmpty ? "Unknown Artist" : fullname
	}
}

struct UnsplashUserPhotoLinks: Decodable {
	let html: URL
}


