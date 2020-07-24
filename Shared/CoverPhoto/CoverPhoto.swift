//
//  CoverPhotoView.swift
//  UnsplashTester
//
//  Created by Marlon Raskin on 7/19/20.
//

import SwiftUI
import SDWebImageSwiftUI

struct CoverPhoto: View {

	var url: URL?
	var proxy: GeometryProxy
	var api: UnsplashAPIService

	@Binding var keyword: String
	@Binding var selectedOption: Int
	@Binding var showCoverPhoto: Bool
	@Binding var image: UIImage?
	@Binding var isEditing: Bool

	var body: some View {
		VStack {
			ZStack(alignment: Alignment(horizontal: .center, vertical: .center)) {
				switch selectedOption {
				case 0:
					ZStack {
						if let image = image {
							Image(uiImage: image)
								.resizable()
								.aspectRatio(contentMode: .fill)
								.frame(height: proxy.size.height / 3.5)
								.frame(maxWidth: 390)
								.background(Color.gray.opacity(0.2))
								.cornerRadius(12)
						} else {
							Image(systemName: "photo")
								.font(.title2)
								.foregroundColor(Color(UIColor.systemGray4))
						}
					}
				case 1:
					WebImage(url: url)
						.resizable()
						.indicator(Indicator.progress)
						.aspectRatio(contentMode: .fill)
						.frame(height: proxy.size.height / 3.5)
						.frame(maxWidth: 390)
						.background(Color.gray.opacity(0.2))
						.cornerRadius(12)
				default:
					ZStack {
						if let image = image {
							Image(uiImage: image)
								.resizable()
								.aspectRatio(contentMode: .fill)
								.frame(height: proxy.size.height / 3.5)
								.frame(maxWidth: 390)
								.background(Color.gray.opacity(0.2))
								.cornerRadius(12)
						} else {
							Image(systemName: "photo")
								.font(.title2)
								.foregroundColor(Color(UIColor.systemGray4))
						}
					}
				}

				CreditAndPhotoToggleView(image: $image, keyword: $keyword, selectedOption: $selectedOption, api: api)
			}

			CoverPhotoControlsView(
				api: api,
				keyword: $keyword,
				selectedOption: $selectedOption,
				showCoverPhoto: $showCoverPhoto,
				image: $image,
				isEditing: $isEditing
			)
			.frame(height: 120)
		}
		.background(Color.gray.opacity(0.15))
		.clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
	}
}

struct CoverPhoto_Previews: PreviewProvider {
	static var previews: some View {
		GeometryReader(content: { geometry in
			CoverPhoto(url: nil,
					   proxy: geometry,
					   api: UnsplashAPIService(),
					   keyword: .constant("Hiking"),
					   selectedOption: .constant(0),
					   showCoverPhoto: .constant(true),
					   image: .constant(UIImage()),
					   isEditing: .constant(true))
		})
	}
}

struct CreditAndPhotoToggleView: View {

	@Binding var image: UIImage?
	@Binding var keyword: String
	@Binding var selectedOption: Int
	var api: UnsplashAPIService

	var body: some View {
		HStack {
			if selectedOption == 1 {
				Link("\(api.result?.user.first_name ?? "") \(api.result?.user.last_name ?? "")",
					 destination: (api.result?.user.links.html ?? URL(string: "https://www.unsplash.com"))!)
					.font(.caption2)
					.foregroundColor(.white)
					.padding(.all, 5)
					.background(Color.black.opacity(0.4))
					.cornerRadius(6)
					.offset(x: 12, y: 90)
			}

			Spacer()

			Button(action: {
				if selectedOption == 1 {
					keyword.isEmpty ? api.fetch(.random) : api.fetch(.search(query: keyword))
				} else {
					image = UIImage()
				}
			}, label: {
				Image(systemName: selectedOption == 1 ? "arrow.clockwise.circle.fill" : "xmark.circle.fill")
					.opacity(selectedOption == 1 && image == UIImage() ? 0 : 1)
					.font(.title3)
					.foregroundColor(.white).opacity(0.7)
			})
			.offset(x: -12, y: 90)
		}
	}
}
