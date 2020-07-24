//
//  ContentView.swift
//  Shared
//
//  Created by Marlon Raskin on 7/19/20.
//

import SwiftUI
import SDWebImageSwiftUI
import PhotosUI

struct CoverPhotoMain: View {

	@ObservedObject var unsplashAPI = UnsplashAPIService()

	@State private var showCoverPhoto: Bool = false
	@State private var keywordText: String = ""
	@State private var selectedPhotoOption: Int = 0
	@State var image: UIImage?
	@State private var isEditing: Bool = false

    var body: some View {
		NavigationView {
			GeometryReader { proxy in
				ZStack {
					VStack(spacing: 20) {
						if showCoverPhoto {
							CoverPhoto(
								url: unsplashAPI.result?.urls.regular,
								proxy: proxy,
								api: unsplashAPI,
								keyword: $keywordText,
								selectedOption: $selectedPhotoOption,
								showCoverPhoto: $showCoverPhoto,
								image: $image,
								isEditing: $isEditing
							)
						}

						VStack(spacing: 20) {
							HStack(spacing: 16) {
								Text("Add Cover Photo")
								Spacer()
								Image(systemName: showCoverPhoto ? "checkmark.circle.fill" : "circle")
									.font(.title2)
									.foregroundColor(.secondary)
							}
							.onTapGesture { showCoverPhoto.toggle() }
							.padding(.horizontal, 20)
						}
						Spacer()
					}
					.padding(.horizontal, 10)
					.animation(.spring())
				}
				.padding(.top)
			}
			.accentColor(.blue)
			.onAppear {
				unsplashAPI.fetch(.random)
			}
			.navigationBarTitle(Text("Cover Photo"), displayMode: .inline)
			.navigationBarItems(trailing: Button(action: {
				isEditing.toggle()
			}, label: {
				Text(isEditing ? "Done": "Edit")
			}))
		}
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
		CoverPhotoMain(image: UIImage())
			.previewDevice("iPhone 11 Pro")
    }
}
