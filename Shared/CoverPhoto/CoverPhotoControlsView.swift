//
//  CoverPhotoControlsView.swift
//  UnsplashTester
//
//  Created by Marlon Raskin on 7/19/20.
//

import SwiftUI

struct CoverPhotoControlsView: View {

	var api: UnsplashAPIService

	@Binding var keyword: String
	@Binding var selectedOption: Int
	@Binding var showCoverPhoto: Bool
	@Binding var image: UIImage

	@State var showPicker: Bool = false
	@State var isEditing: Bool = false

	var body: some View {
		VStack(spacing: 16) {
			ZStack {
				Capsule()
					.strokeBorder(Color.gray, style: StrokeStyle(lineWidth: 1), antialiased: true)
					.frame(height: 45, alignment: .center)

				if selectedOption == 0 {
					HStack(spacing: 3) {
						TextField("Outdoors, eg.",
								  text: $keyword) { editing in
								isEditing = editing
							}
							onCommit: {
								if !keyword.isEmpty { api.fetch(.search(query: keyword)) }
							}
							.accentColor(.primary)
							.frame(alignment: .center)
							.padding(.horizontal, 20)
						if isEditing {
							Image(systemName: "xmark.circle.fill")
								.foregroundColor(.gray)
								.padding(.trailing)
								.onTapGesture {
									keyword = ""
								}
						}
					}
				} else {
					Button("Choose Photo") {
						showPicker.toggle()
					}
					.foregroundColor(.primary)
				}
			}

			SourceOptionsSelector(selectedOption: $selectedOption)

		}
		.padding(.horizontal)
		.padding(.top, 10)
		.padding(.bottom, 10)
		.sheet(isPresented: $showPicker) {
			ImagePicker(image: $image, showingPicker: $showPicker)
		}
	}
}


struct SourceOptionsSelector: View {

	@Binding var selectedOption: Int

	var body: some View {
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
}

struct CoverPhotoControlsView_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			CoverPhotoControlsView(api: UnsplashAPIService(), keyword: .constant(""), selectedOption: .constant(0), showCoverPhoto: .constant(true), image: .constant(UIImage(systemName: "paperplane")!))
			SourceOptionsSelector(selectedOption: .constant(0))
		}
	}
}
