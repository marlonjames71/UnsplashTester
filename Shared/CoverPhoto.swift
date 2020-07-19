//
//  ContentView.swift
//  Shared
//
//  Created by Marlon Raskin on 7/19/20.
//

import SwiftUI
import SDWebImageSwiftUI
import PhotosUI

struct CoverPhotoView: View {

	@ObservedObject var unsplashAPI = UnsplashAPIService()

	@State private var showCoverPhoto: Bool = false
	@State private var keywordText: String = ""
	@State private var selectedPhotoOption: Int = 0

    var body: some View {
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
							showCoverPhoto: $showCoverPhoto
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
		}
		.accentColor(.blue)
		.onAppear {
			unsplashAPI.fetch(.random)
		}
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
		CoverPhotoView()
			.previewDevice("iPhone 11 Pro")
    }
}

struct CoverPhoto: View {

	var url: URL?
	var proxy: GeometryProxy
	var api: UnsplashAPIService

	@Binding var keyword: String
	@Binding var selectedOption: Int
	@Binding var showCoverPhoto: Bool

	var body: some View {
		VStack {
			ZStack(alignment: Alignment(horizontal: .center, vertical: .center)) {
				WebImage(url: url)
					.resizable()
					.indicator(Indicator.progress)
					.aspectRatio(contentMode: .fill)
					.frame(height: proxy.size.height / 3.5)
					.frame(maxWidth: 390)
					.background(Color.gray.opacity(0.2))
					.cornerRadius(12)

				HStack {
					Link("\(api.result?.user.first_name ?? "") \(api.result?.user.last_name ?? "")",
						 destination: (api.result?.user.links.html ?? URL(string: "https://www.unsplash.com"))!)
						.font(.caption2)
						.foregroundColor(.white)
						.padding(.all, 5)
						.background(Color.black.opacity(0.4))
						.cornerRadius(6)
						.offset(x: 12, y: 95)

					Spacer()

					Button(action: {
						keyword.isEmpty ? api.fetch(.random) : api.fetch(.search(query: keyword))
					}, label: {
						Image(systemName: "arrow.clockwise.circle.fill")
							.font(.title3)
							.foregroundColor(.white).opacity(0.7)
					})
					.offset(x: -12, y: 95)
				}
			}

			CoverPhotoControlsView(api: api, keyword: $keyword, selectedOption: $selectedOption, showCoverPhoto: $showCoverPhoto)
				.frame(height: 120)
		}
		.background(Color.gray.opacity(0.15))
		.clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
	}
}

struct CoverPhotoControlsView: View {

	var api: UnsplashAPIService

	@Binding var keyword: String
	@Binding var selectedOption: Int
	@Binding var showCoverPhoto: Bool

	@State var showPicker: Bool = false

	var body: some View {
		VStack(spacing: 16) {
			ZStack {
				Capsule()
					.strokeBorder(Color.gray, style: StrokeStyle(lineWidth: 1), antialiased: true)
					.frame(height: 45, alignment: .center)

				if selectedOption == 0 {
					TextField("Outdoors, eg.",
							  text: $keyword) {_ in }
						onCommit: { if !keyword.isEmpty { api.fetch(.search(query: keyword)) } }
						.accentColor(.primary)
						.frame(alignment: .center)
						.padding(.horizontal, 20)
				} else {
					Button("Choose Photo") {
						showPicker.toggle()
					}
					.foregroundColor(.primary)
				}
			}

			HStack(spacing: 16) {
				Spacer()

				HStack(spacing: 8) {
					Text("Unsplash")
					Image(systemName: selectedOption == 0 ? "checkmark.circle.fill" : "circle")
				}.tag(0)
				.onTapGesture {
					selectedOption = 0
				}

				Spacer()

				HStack(spacing: 8) {
					Text("Photo Library")
					Image(systemName: selectedOption == 1 ? "checkmark.circle.fill" : "circle")
				}.tag(1)
				.onTapGesture {
					selectedOption = 1
				}

				Spacer()
			}
		}
		.padding(.horizontal)
		.padding(.top, 10)
		.padding(.bottom, 10)
	}
}
