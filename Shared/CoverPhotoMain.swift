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

	@State private var showCoverPhoto: Bool = true
	@State private var keywordText: String = ""
	@State private var selectedPhotoOption: Int = 0
	@State var image: UIImage?
	@State private var isEditing: Bool = false

	private var imagePadding: CGFloat {
		isEditing ? 10 : 0
	}

	var body: some View {
		ScrollView {
			ZStack {
				VStack(spacing: 20) {
					if showCoverPhoto {
						ZStack(alignment: .bottom) {
							CoverPhotoView(
								url: unsplashAPI.result?.urls.regular,
								api: unsplashAPI,
								keyword: $keywordText,
								selectedOption: $selectedPhotoOption,
								showCoverPhoto: $showCoverPhoto,
								image: $image,
								isEditing: $isEditing
							)
							.frame(maxWidth: UIScreen.main.bounds.width - imagePadding * 2)
							.frame(height: UIScreen.main.bounds.height / 3 + 50)
							.cornerRadius(isEditing ? 10 : 0)
							.clipped()

							CreditAndRefreshView(image: $image, keyword: $keywordText, selectedOption: $selectedPhotoOption, isEditing: $isEditing, api: unsplashAPI)
								.padding([.horizontal, .bottom], 12)
						}

					}

					if isEditing {
						CoverPhotoControlsView(
							api: unsplashAPI,
							keyword: $keywordText,
							selectedOption: $selectedPhotoOption,
							showCoverPhoto: $showCoverPhoto,
							image: $image,
							isEditing: $isEditing
						)
						.transition(AnyTransition.scale.combined(with: .opacity))
						.animation(.easeInOut)
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

					Button(action: {

						guard showCoverPhoto else { return }
						isEditing.toggle()
					}, label: {
						Text(isEditing ? "Done": "Edit")
					})
					.padding(.bottom, 20)
				}
				.padding(.horizontal, imagePadding)
				.animation(.spring())
			}
			.padding(.top, showCoverPhoto ? 0 : 10)
			.padding(.top, imagePadding)
			.accentColor(.blue)
			.onAppear {
				unsplashAPI.fetch(.random)
			}
		}
		.ignoresSafeArea(.all, edges: ignoreTopEdge ? .top : [])
		.animation(.easeInOut)
//		.edgesIgnoringSafeArea(.top)
	}

	var ignoreTopEdge: Bool {
		if showCoverPhoto {
			if isEditing {
				return false
			} else {
				return true
			}
		} else {
			return false
		}
//		guard !showCoverPhoto else { return false }
//		if isEditing { return true }
//		return false
	}
}

struct MainView_Previews: PreviewProvider {
	static var previews: some View {
		CoverPhotoMain(image: UIImage())
			.previewDevice("iPhone 11 Pro")
	}
}
