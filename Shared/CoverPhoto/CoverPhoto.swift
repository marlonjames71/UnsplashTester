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
				GeometryReader { geo in
					switch selectedOption {
					case 0:
						ZStack {
							if let image = image {
								Image(uiImage: image)
									.resizable()
									.aspectRatio(contentMode: .fill)
									.frame(minHeight: proxy.size.height / 3, maxHeight: proxy.size.height / 3)
									.frame(minWidth: geo.size.width, maxWidth: geo.size.width)
									.background(Color.gray.opacity(0.2))
							} else {
								Image(systemName: "photo")
									.resizable()
									.frame(minHeight: proxy.size.height / 3, maxHeight: proxy.size.height / 3)
									.font(.title2)
									.foregroundColor(Color(UIColor.systemGray4))
							}
						}
						.clipped()
					case 1:
						WebImage(url: url)
							.resizable()
							.indicator(Indicator.progress)
							.aspectRatio(contentMode: .fill)
							.frame(minHeight: proxy.size.height / 3, maxHeight: proxy.size.height / 3)
							.frame(minWidth: geo.size.width, maxWidth: geo.size.width)
							.background(Color.gray.opacity(0.2))
					default:
						ZStack {
							if let image = image {
								Image(uiImage: image)
									.resizable()
									.aspectRatio(contentMode: .fill)
									.frame(minHeight: proxy.size.height / 3, maxHeight: proxy.size.height / 3)
									.frame(minWidth: geo.size.width, maxWidth: geo.size.width)
									.background(Color.gray.opacity(0.2))
							} else {
								Image(systemName: "photo")
									.font(.title2)
									.foregroundColor(Color(UIColor.systemGray4))
									.position(CGPoint(x: geo.size.width / 2, y: geo.size.height / 2))
							}
						}
						.frame(minWidth: geo.size.width, maxWidth: geo.size.width)
					}
				}

//				CreditAndPhotoToggleView(image: $image, keyword: $keyword, selectedOption: $selectedOption, isEditing: $isEditing, geo: proxy, api: api)
//					.padding(.bottom)
			}
			.animation(.default)
			.clipped()

			CoverPhotoControlsView(
				api: api,
				keyword: $keyword,
				selectedOption: $selectedOption,
				showCoverPhoto: $showCoverPhoto,
				image: $image,
				isEditing: $isEditing
			)
			.frame(minHeight: 90)
			.padding(.bottom, 5)
		}
		.layoutPriority(1)
		.frame(maxHeight: 320)
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
