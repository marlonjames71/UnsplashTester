//
//  ImagePicker.swift
//  UnsplashTester
//
//  Created by Marlon Raskin on 7/19/20.
//

import SwiftUI
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {

	@Binding var image: UIImage
	@Binding var showingPicker: Bool

	func makeCoordinator() -> ImagePickerCoordinator {
		ImagePicker.Coordinator(pickerParent: self)
	}

	func makeUIViewController(context: Context) -> PHPickerViewController {
		var config = PHPickerConfiguration()
		config.filter = .images
		config.selectionLimit = 1
		let picker = PHPickerViewController(configuration: config)
		picker.delegate = context.coordinator
		return picker
	}

	func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

class ImagePickerCoordinator: NSObject, PHPickerViewControllerDelegate {
	var parent: ImagePicker

	init(pickerParent: ImagePicker) {
		parent = pickerParent
	}

	func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {

		parent.showingPicker.toggle()

		guard let image = results.first else { return }
		if image.itemProvider.canLoadObject(ofClass: UIImage.self) {
			image.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { [weak self] imgItem, error in
				guard let item = imgItem as? UIImage else { print(error?.localizedDescription ?? "Error loading item"); return }
				self?.parent.image = item
			})
		} else {
			print("Image cannot be loaded")
		}
	}
}
