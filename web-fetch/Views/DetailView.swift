//
//  DetailView.swift
//  web-fetch
//
//  Created by Thalia Nero on 4/8/24.
//

import SwiftUI

struct DetailView: View {
    var mealId: String
    
    @State private var detail: MealDetail?
    @State private var image: Image = Image(systemName: "photo")
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(detail?.name ?? "")
                .font(.title)
            image
            ScrollView {
                VStack(alignment: .leading) {
                    Text(LocalizedStringKey("ingredients"))
                        .font(.headline)
                    ForEach(detail?.ingredients ?? []) { ingredient in
                        HStack {
                            Text(ingredient.measure)
                            Text(ingredient.name)
                            Spacer()
                        }
                    }
                }
                .padding(.bottom, 10.0)
                Text(detail?.instructions ?? "")
            }
        }
        .padding(.horizontal, 15.0)
        .task {
            detail = await loadDetail(mealId: mealId)
            if let detail {
                image = await loadImage(detail.image)
            }
        }
    }
}

#Preview {
    DetailView(mealId: "53049")
}
