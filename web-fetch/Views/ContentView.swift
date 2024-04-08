//
//  ContentView.swift
//  web-fetch
//
//  Created by Thalia Nero on 4/5/24.
//

import SwiftUI

struct ContentView: View {
    @State var summaries: [MealSummary] = []
    
    var body: some View {
        VStack {
            Text(LocalizedStringKey("desserts"))
                .font(.title)
            SummaryView(summaries: summaries)
                .task {
                    var summaries = await loadSummaries(url: summaryUrl)
                    summaries.sort { $0.name < $1.name }
                    self.summaries = summaries
                }
        }
    }
}

#Preview {
    ContentView()
}
