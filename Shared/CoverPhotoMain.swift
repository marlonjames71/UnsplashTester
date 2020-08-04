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
							coverPhoto
							.frame(maxWidth: UIScreen.main.bounds.width - imagePadding * 2)
							.frame(height: UIScreen.main.bounds.height / 3 + 50)
							.cornerRadius(isEditing ? 10 : 0)
							.clipped()

							creditAndRefreshView
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


extension CoverPhotoMain {
	var creditAndRefreshView: some View {
		HStack {
			if selectedPhotoOption == 1 {
				Link("\(unsplashAPI.result?.user.first_name ?? "") \(unsplashAPI.result?.user.last_name ?? "")",
					 destination: (unsplashAPI.result?.user.links.html ?? URL(string: "https://www.unsplash.com"))!)
					.font(.caption2)
					.foregroundColor(.white)
					.padding(.all, 5)
					.background(Color.black.opacity(0.4))
					.cornerRadius(6)
			}

			Spacer()

			Button(action: {
				if selectedPhotoOption == 1 {
					keywordText.isEmpty ? unsplashAPI.fetch(.random) : unsplashAPI.fetch(.search(query: keywordText))
				} else {
					image = nil
				}
			}, label: {
				if isEditing {
					Image(systemName: selectedPhotoOption == 1 ? "arrow.clockwise.circle.fill" : "xmark.circle.fill")
						.opacity(selectedPhotoOption > 0 ? 1 : 0)
						.font(.title3)
						.foregroundColor(.white).opacity(0.7)
				}
			})
		}
	}
}


extension CoverPhotoMain {
	var coverPhoto: some View {
		ZStack {
			switch selectedPhotoOption {
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
				WebImage(url: unsplashAPI.result?.urls.regular)
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


struct MainView_Previews: PreviewProvider {
	static var previews: some View {
		CoverPhotoMain(image: UIImage())
			.previewDevice("iPhone 11 Pro")
	}
}
