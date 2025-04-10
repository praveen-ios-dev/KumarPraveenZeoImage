//
//  PexelsGridView.swift
//  KumarPraveenZeoImage
//
//  Created by Praveen on 10/04/25.
//

import SwiftUI

struct PexelsGridView: View {
    @StateObject private var viewModel = PexelsViewModel()
    @State private var selectedPhoto: PexelsPhoto? = nil

    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.photos.isEmpty {
                    EmptyView()
                } else {
                    GridView(model: viewModel)
                }
            }
            .navigationTitle(AppConstant.NavigaationTitle)
            .searchable(text: $viewModel.query, prompt: AppConstant.placeholderText)
            .navigationDestination(for: PexelsPhoto.self) { photo in
                DetailView(photo: photo)
            }
        }
    }
}



#Preview {
    PexelsGridView()
}
