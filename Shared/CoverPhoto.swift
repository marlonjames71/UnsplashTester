//
//  ContentView.swift
//  Shared
//
//  Created by Marlon Raskin on 7/19/20.
//

import SwiftUI
import SDWebImageSwiftUI
import PhotosUI

struct CoverPhoto: View {

	@ObservedObject var unsplashAPI: UnsplashAPIService

	@Binding var isEditing: Bool
	@Binding var image: UIImage?

	@Binding var keywordText: String
	@Binding var selectedPhotoOption: OptionSelector

	private var imagePadding: CGFloat {
		isEditing ? 10 : 0
	}

	var body: some View {
		ZStack(alignment: .bottom) {
			coverPhoto
				.frame(maxWidth: UIScreen.main.bounds.width - imagePadding * 2)
				.frame(height: UIScreen.main.bounds.height / 3 + 50)
				.cornerRadius(isEditing ? 10 : 0)
				.clipped()

			creditAndRefreshView
				.padding([.horizontal, .bottom], 14)
		}
		.padding(.horizontal, imagePadding)
		.padding(.top, imagePadding)
		.onAppear {
			guard unsplashAPI.result == nil else { return }
			unsplashAPI.fetch(.random)
		}
	}


	enum OptionSelector: Int, CaseIterable {
		case previous
		case unsplash
		case photoLibrary

		var presentationName: String {
			switch self {
			case .previous:
				return "Previous"
			case .unsplash:
				return "Unsplash"
			case .photoLibrary:
				return "Photo Library"
			}
		}
	}
}


extension CoverPhoto {
	var creditAndRefreshView: some View {
		HStack {
			if selectedPhotoOption == .unsplash {
				Link(unsplashAPI.result?.user.presentationName ?? "",
					 destination: (unsplashAPI.result?.user.links.html ?? URL(string: "https://www.unsplash.com"))!)
					.font(.caption2)
					.foregroundColor(.white)
					.padding(.all, 5)
					.background(Color.black.opacity(0.4))
					.cornerRadius(6)
			}

			Spacer()

			Button(action: {
				if selectedPhotoOption == .unsplash {
					keywordText.isEmpty ? unsplashAPI.fetch(.random) : unsplashAPI.fetch(.search(query: keywordText))
				} else {
					image = nil
				}
			}, label: {
				if isEditing {
					Image(systemName: selectedPhotoOption == .unsplash ? "arrow.clockwise.circle.fill" : "xmark.circle.fill")
						.opacity(selectedPhotoOption.rawValue > 0 ? 1 : 0)
						.font(.title3)
						.foregroundColor(.white).opacity(0.7)
				}
			})
		}
	}
}


extension CoverPhoto {
	var coverPhoto: some View {
		ZStack {
			switch selectedPhotoOption {
			case .previous:
				ZStack {
					if let image = image {
						Image(uiImage: image)
							.resizable()
							.aspectRatio(contentMode: .fill)
							.background(Color.gray.opacity(0.2))
					} else {
						Image(systemName: "photo")
							.resizable()
							.font(.title2)
							.foregroundColor(Color(UIColor.systemGray4))
					}
				}
			case .unsplash:
				WebImage(url: unsplashAPI.result?.urls.regular)
					.resizable()
					.indicator(Indicator.progress)
					.aspectRatio(contentMode: .fill)
					.background(Color.gray.opacity(0.2))
			case .photoLibrary:
				ZStack {
					if let image = image {
						Image(uiImage: image)
							.resizable()
							.aspectRatio(contentMode: .fill)
							.background(Color.gray.opacity(0.2))
					} else {
						Image(systemName: "photo")
							.font(.title2)
							.foregroundColor(Color(UIColor.systemGray4))
					}
				}
			}
		}
	}
}
