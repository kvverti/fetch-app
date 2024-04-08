//
//  DessertEntryView.swift
//  web-fetch
//
//  Created by Thalia Nero on 4/6/24.
//

import SwiftUI

struct DessertEntryView: View {
    var mealSummary: MealSummary
    
    @State private var thumbnail: Image = Image(systemName: "photo")
    
    var body: some View {
        HStack {
            thumbnail
                .frame(width: 70, height: 70)
            Text(mealSummary.name)
        }
        .task {
            thumbnail = await loadImage(mealSummary.previewUrl)
        }
    }
}

#Preview{
    Group {
        DessertEntryView(mealSummary: MealSummary(id: "1", name: "Apam balik", imageUrl: URL(string: "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg")!))
        DessertEntryView(mealSummary: MealSummary(id: "52932", name: "Pouding chomeur", imageUrl: URL(string: "https://www.themealdb.com/images/media/meals/yqqqwu1511816912.jpg")!))
    }
}
