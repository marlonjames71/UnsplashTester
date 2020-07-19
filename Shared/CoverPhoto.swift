//
//  ContentView.swift
//  Shared
//
//  Created by Marlon Raskin on 7/19/20.
//

import SwiftUI
import SDWebImageSwiftUI

struct CoverPhotoView: View {

	@ObservedObject var unsplashAPI = UnsplashAPIService()

	@State private var showCoverPhoto: Bool = false

    var body: some View {
		GeometryReader { proxy in
			VStack(spacing: 20) {
				if showCoverPhoto {
					ZStack(alignment: Alignment(horizontal: .leading, vertical: .center)) {
						WebImage(url: unsplashAPI.result?.urls.regular)
							.resizable()
							.indicator(Indicator.progress)
							.aspectRatio(contentMode: .fill)
							.frame(height: proxy.size.height / 3.5)
							.frame(maxWidth: 350)
							.background(Color.gray.opacity(0.2))
							.cornerRadius(16)

						HStack {
							Text("\(unsplashAPI.result?.user.first_name ?? "") \(unsplashAPI.result?.user.last_name ?? "")")
								.font(.caption2)
								.padding(.all, 5)
								.background(Color.black.opacity(0.4))
								.cornerRadius(6)
								.offset(x: 8, y: 85)
								.onTapGesture {
									if UIApplication.shared.canOpenURL((unsplashAPI.result?.user.links.html ?? URL(string: "https://www.unsplash.com"))!) {
										UIApplication.shared.open(unsplashAPI.result?.user.links.html ?? URL(string: "https://www.unsplash.com")!, options: [.universalLinksOnly : (Any).self]) { _ in
											// Code here
										}
									}
								}
							Spacer()

							Button(action: {
								unsplashAPI.fetch(.random)
							}, label: {
								Image(systemName: "arrow.clockwise.circle.fill")
									.font(.title3)
									.foregroundColor(.white).opacity(0.7)
							})
							.offset(x: -8, y: 85)
						}
					}
				}

				VStack(spacing: 20) {
					HStack(spacing: 16) {
						Text("Add Cover Photo")
						Spacer()
						Image(systemName: showCoverPhoto ? "checkmark.circle.fill" : "circle")
							.font(.title2)
							.foregroundColor(.secondary)
							.onTapGesture { showCoverPhoto.toggle() }
					}
					.padding(.horizontal)
				}
				Spacer()
			}
			.padding(.horizontal)
			.animation(.spring())
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
