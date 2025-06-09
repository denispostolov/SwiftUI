//
//  GridActivities.swift
//  DotDot
//
//  Created by Denis Postolov on 17/05/25.
//

import SwiftUI

struct GridActivities: View {
    @Binding var currentActivities: [Activity]
    let columns = [GridItem(.adaptive(minimum: 150))]
    
    var body: some View {
        if(currentActivities.isEmpty){
            Text("No activities found")
        } else {
            ScrollView {
                LazyVGrid(columns: columns){
                    ForEach(currentActivities) { activity in
                        NavigationLink(value: activity, label: {
                           ActivityCard(activity: activity)
                        })
                    }
                }
                .padding([.horizontal, .top, .bottom])
                .navigationDestination(for: Activity.self, destination: { activity in
                    if let index = currentActivities.firstIndex(where: {$0.id == activity.id}) {
                        ActivityView(activity: $currentActivities[index], currentActivities: $currentActivities)
                    }
                })
            }
        }
    }
}

