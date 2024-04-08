//
//  SummaryView.swift
//  web-fetch
//
//  Created by Thalia Nero on 4/6/24.
//

import SwiftUI

struct SummaryView: View {
    var summaries: [MealSummary]
    
    var body: some View {
        NavigationSplitView {
            List {
                ForEach(summaries) { mealSummary in
                    NavigationLink {
                        DetailView(mealId: mealSummary.id)
                    } label: {               DessertEntryView(mealSummary: mealSummary)
                    }
                }
            }
        } detail: {
            Text(LocalizedStringKey("mealSelect"))
        }
    }
}

#Preview {
    let summaries = [MealSummary(id: "53049", name: "Apam balik", imageUrl: URL(string: "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg")!)];
    return SummaryView(summaries: summaries)
}
