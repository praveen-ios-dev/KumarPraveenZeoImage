//
//  RemoteImageView.swift
//  KumarPraveenZeoImage
//
//  Created by Praveen on 10/04/25.
//

import SwiftUI

struct RemoteImageView: View {
    let url: URL
    @State private var image: UIImage?
    
    var body: some View {
        Group {
            if let uiImage = image {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                Color.gray.opacity(0.2)
                    .onAppear(perform: loadImage)
            }
        }
        .frame(width: ((UIScreen.main.bounds.width / 2) - 12), height: 200)
        .clipped()
    }
    
    private func loadImage() {
        if let cached = ImageCache.shared.image(for: url) {
            image = cached
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let uiImage = UIImage(data: data) {
                ImageCache.shared.insertImage(uiImage, for: url)
                DispatchQueue.main.async {
                    image = uiImage
                }
            }
        }.resume()
    }
}

#Preview {
    RemoteImageView(url: URL(string: "https://images.pexels.com/photos/3933246/pexels-photo-3933246.jpeg")!)
}
