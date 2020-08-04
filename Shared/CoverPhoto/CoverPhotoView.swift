//
//  CoverPhotoView.swift
//  UnsplashTester
//
//  Created by Marlon Raskin on 8/4/20.
//

import SwiftUI
import SDWebImageSwiftUI

struct CoverPhotoView: View {
	var url: URL?
	var api: UnsplashAPIService

	@Binding var keyword: String
	@Binding var selectedOption: Int
	@Binding var showCoverPhoto: Bool
	@Binding var image: UIImage?
	@Binding var isEditing: Bool


	var body: some View {
		ZStack {
			switch selectedOption {
			case 0:
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
			case 1:
				WebImage(url: url)
					.resizable()
					.indicator(Indicator.progress)
					.aspectRatio(contentMode: .fill)
					.background(Color.gray.opacity(0.2))
			default:
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

//struct CoverPhotoView_Previews: PreviewProvider {
//    static var previews: some View {
//        CoverPhotoView()
//    }
//}
