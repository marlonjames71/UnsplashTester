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
	@Binding var image: UIImage?

	@State var showPicker: Bool = false
	@Binding var isEditing: Bool

	var body: some View {
		VStack(spacing: 16) {
			ZStack {
				Capsule()
					.strokeBorder(Color.gray, style: StrokeStyle(lineWidth: 1), antialiased: true)
					.frame(height: 45, alignment: .center)

				if selectedOption == 0 {
					HStack {
						Text("Previously Uploaded")
							.font(.caption)
						Image(systemName: "checkmark.icloud.fill")
							.foregroundColor(.green)
							.font(.caption)
					}
				}
				else if selectedOption == 1 {
					HStack(spacing: 3) {
						if isEditing {
							TextField("Outdoors, eg.",
									  text: $keyword) { editing in
//								isEditing = editing
							}
							onCommit: {
								if !keyword.isEmpty { api.fetch(.search(query: keyword)) }
							}
							.accentColor(.primary)
							.frame(alignment: .center)
							.padding(.horizontal, 20)
						} else {
							Text(keyword)
						}
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
					if isEditing {
						Button("Choose Photo") {
							showPicker.toggle()
						}
						.foregroundColor(.primary)
					} else {
						Text("Edit to choose photo")
					}
				}
			}

			SourceOptionsSelector(selectedOption: $selectedOption, isEditing: $isEditing)

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
	@Binding var isEditing: Bool

	var body: some View {
		if isEditing {
			HStack(spacing: 25) {

				HStack(spacing: 8) {
					Text("Previous")
						.font(.caption)
					Image(systemName: selectedOption == 0 ? "checkmark.circle.fill" : "circle")
				}.tag(0)
				.onTapGesture {
					selectedOption = 0
				}

				HStack(spacing: 8) {
					Text("Unsplash")
						.font(.caption)
					Image(systemName: selectedOption == 1 ? "checkmark.circle.fill" : "circle")
				}.tag(1)
				.onTapGesture {
					selectedOption = 1
				}

				HStack(spacing: 8) {
					Text("Photo Library")
						.font(.caption)
					Image(systemName: selectedOption == 2 ? "checkmark.circle.fill" : "circle")
				}.tag(2)
				.onTapGesture {
					selectedOption = 2
				}

			}
		}
	}
}

struct CoverPhotoControlsView_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			CoverPhotoControlsView(api: UnsplashAPIService(), keyword: .constant(""), selectedOption: .constant(0), showCoverPhoto: .constant(true), image: .constant(UIImage(systemName: "paperplane")!), isEditing: .constant(true))
			SourceOptionsSelector(selectedOption: .constant(0), isEditing: .constant(true))
		}
	}
}
