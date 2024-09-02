//
//  LoadImageView.swift
//  NYTimesTask
//
//  Created by Monish Kumar on 03/09/24.
//

import SwiftUI

struct LoadImageView: View {
    @State private var uiImage: UIImage? = nil
    let url: URL

    var body: some View {
        Group {
            if let uiImage = uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
            } else {
                ProgressView()
            }
        }
        .onAppear {
            fetchImage()
        }
    }

    private func fetchImage() {
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.uiImage = image
                }
            }
        }
        task.resume()
    }
}
