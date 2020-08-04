//
//  UnsplashTesterApp.swift
//  Shared
//
//  Created by Marlon Raskin on 7/19/20.
//

import SwiftUI

@main
struct UnsplashTesterApp: App {
	var body: some Scene {
		WindowGroup {
			RootView()
		}
	}
}


struct RootView: View {

	let unsplashAPI = UnsplashAPIService()

	@State private var isEditing: Bool = false
	@State private var showCoverPhoto: Bool = false
	@State private var image: UIImage?
	@State private var keywordText: String = ""
	@State private var selectedPhotoOption: CoverPhoto.OptionSelector = .previous

	var body: some View {
		ScrollView {
			VStack(spacing: 20) {
				if showCoverPhoto {
					CoverPhoto(
						unsplashAPI: unsplashAPI,
						isEditing: $isEditing,
						image: $image,
						keywordText: $keywordText,
						selectedPhotoOption: $selectedPhotoOption
					)
					.transition(AnyTransition.move(edge: .top).combined(with: .opacity))
					.animation(.spring())

					if isEditing {
						CoverPhotoControlsView(
							api: unsplashAPI,
							keyword: $keywordText,
							selectedOption: $selectedPhotoOption,
							image: $image,
							isEditing: $isEditing
						)
						.transition(AnyTransition.scale.combined(with: .opacity))
					}
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
				.animation(.spring())

				Button(action: {
					guard showCoverPhoto else { return }
					isEditing.toggle()
				}, label: {
					Text(isEditing ? "Done": "Edit")
				})
				.padding(.bottom, 20)
				.animation(Animation.spring(response: showCoverPhoto ? 0.55 : 0.62, dampingFraction: 0.825, blendDuration: 0))

				Spacer()
			}
			.animation(.spring())
		}
		.ignoresSafeArea(.all, edges: ignoreTopEdge ? .top : [])
		.animation(.easeInOut)
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
	}
}
