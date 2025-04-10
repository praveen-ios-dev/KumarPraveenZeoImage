//
//  EmptyView.swift
//  KumarPraveenZeoImage
//
//  Created by Praveen on 10/04/25.
//

import SwiftUI

struct EmptyView: View {
    var body: some View {
        Text(AppConstant.noResultFound)
            .foregroundColor(.gray)
            .font(.headline)
        Spacer()
    }
}

#Preview {
    EmptyView()
}
