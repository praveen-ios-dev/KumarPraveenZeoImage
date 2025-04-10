//
//  GridView.swift
//  KumarPraveenZeoImage
//
//  Created by Praveen on 10/04/25.
//

import SwiftUI

struct GridView: View {
    let model : PexelsViewModel
    let columns = [
        GridItem(.fixed((UIScreen.main.bounds.width / 2) - 12)),
        GridItem(.fixed((UIScreen.main.bounds.width / 2) - 12))
    ]
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(model.photos) { photo in
                    if let url = URL(string: photo.src.original) {
                        NavigationLink(value: photo) {
                            RemoteImageView(url: url)
                                .onAppear {
                                    model.loadMoreIfNeeded(currentItem: photo)
                                }
                                .background(Color(hex: photo.avgColor))
                                .cornerRadius(8)
                        }
                    }
                }
            }
            .padding()
        }
    }
}
