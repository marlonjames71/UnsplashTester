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
	@Binding var selectedOption: CoverPhoto.OptionSelector
	@Binding var image: UIImage?

	@State var showPicker: Bool = false
	@Binding var isEditing: Bool

	var body: some View {
		VStack(spacing: 16) {
			ZStack {
				Capsule()
					.strokeBorder(Color.gray, style: StrokeStyle(lineWidth: 1), antialiased: true)
					.frame(height: 45, alignment: .center)

				switch selectedOption {
				case .previous:
					imageDashboardPrevious
				case .unsplash:
					imageDashboardUnsplash
				case .photoLibrary:
					imageDashboardPhotoLibrary
				}
			}

			if isEditing {
				sourceOptionSelector
			}

		}
		.animation(.default)
		.padding(.horizontal)
		.padding(.top, 10)
		.padding(.bottom, 10)
		.sheet(isPresented: $showPicker) {
			ImagePicker(image: $image, showingPicker: $showPicker)
		}
	}


	private var imageDashboardPrevious: some View {
		HStack {
			Text("Previously Uploaded")
				.font(.caption)

			Image(systemName: "checkmark.icloud.fill")
				.foregroundColor(.green)
				.font(.caption)

		}
	}

	private var imageDashboardUnsplash: some View {
		HStack(spacing: 3) {
			if isEditing {
				TextField("Outdoors, eg.",
						  text: $keyword) { editing in }
				onCommit: {
					if !keyword.isEmpty { api.fetch(.search(query: keyword)) }
				}
				.accentColor(.primary)
				.frame(alignment: .center)
				.padding(.horizontal, 20)
			} else {
				Text(keyword.isEmpty ? "Edit to Search" : keyword)
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
	}

	private var imageDashboardPhotoLibrary: some View {
		Group {
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
}


extension CoverPhotoControlsView {
	var sourceOptionSelector: some View {
		HStack(spacing: 25) {
			ForEach(CoverPhoto.OptionSelector.allCases, id: \.self) { option in
				Label(option.presentationName, systemImage: selectedOption == option ? "checkmark.circle.fill" : "circle")
					.font(.footnote)
					.onTapGesture {
						selectedOption = option
					}
			}
		}
	}
}

struct CoverPhotoControlsView_Previews: PreviewProvider {
	static var previews: some View {
		CoverPhotoControlsView(
			api: UnsplashAPIService(),
			keyword: .constant(""),
			selectedOption: .constant(.unsplash),
			image: .constant(UIImage()),
			isEditing: .constant(true)
		)
	}
}
