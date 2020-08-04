//
//  CreditAndRefreshView.swift
//  UnsplashTester
//
//  Created by Marlon Raskin on 8/4/20.
//

import SwiftUI

struct CreditAndRefreshView: View {

	@Binding var image: UIImage?
	@Binding var keyword: String
	@Binding var selectedOption: Int
	@Binding var isEditing: Bool
	var api: UnsplashAPIService

	var body: some View {
		HStack {
			if selectedOption == 1 {
				Link("\(api.result?.user.first_name ?? "") \(api.result?.user.last_name ?? "")",
					 destination: (api.result?.user.links.html ?? URL(string: "https://www.unsplash.com"))!)
					.font(.caption2)
					.foregroundColor(.white)
					.padding(.all, 5)
					.background(Color.black.opacity(0.4))
					.cornerRadius(6)
			}

			Spacer()

			Button(action: {
				if selectedOption == 1 {
					keyword.isEmpty ? api.fetch(.random) : api.fetch(.search(query: keyword))
				} else {
					image = nil
				}
			}, label: {
				if isEditing {
					Image(systemName: selectedOption == 1 ? "arrow.clockwise.circle.fill" : "xmark.circle.fill")
						.opacity(selectedOption > 0 ? 1 : 0)
						.font(.title3)
						.foregroundColor(.white).opacity(0.7)
				}
			})
		}
	}
}

//struct CreditAndRefreshView_Previews: PreviewProvider {
//    static var previews: some View {
//        CreditAndRefreshView()
//    }
//}
