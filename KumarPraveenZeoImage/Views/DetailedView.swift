//
//  DetailedView.swift
//  KumarPraveenZeoImage
//
//  Created by Praveen on 10/04/25.
//

import SwiftUI

struct DetailView: View {
    let photo: PexelsPhoto
    
    var body: some View {
        ZStack {
            Color(hex: photo.avgColor).opacity(0.5)
                .ignoresSafeArea(edges: .all)
            VStack{
                if let url = URL(string: photo.src.original) {
                    AsyncImage(url: url){image in
                        image.image?
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                            
                    }
                        
                    Text(String(format: AppConstant.imageCreaditMsg, photo.photographer))
                        .font(.headline)
                }
            }
            
        }
    }
}


#Preview {
    DetailView(photo: PexelsPhoto(id: 3933246, photographer: "Tatiana Syrikova", src: Src(original: "https://images.pexels.com/photos/3933246/pexels-photo-3933246.jpeg"), alt: "Rustic wooden frame with letter B arrangement on dry leaves, indoors.", avgColor: "#AD9D8C"))
}
