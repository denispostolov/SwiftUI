//
//  ContentView.swift
//  DotDot
//
//  Created by Denis Postolov on 14/05/25.
//

import SwiftUI


struct HomeView: View {
    
    @State private var showAddActivityView: Bool = false
    
    @State var currentActivities: [Activity] = loadUserActivities()
    
    var body: some View {
        NavigationStack {
            Text("\"A small gesture every day builds a chain of great changes.\"")
                .italic()
                .padding(20)
            GridActivities(currentActivities: $currentActivities)
            .toolbar{
                ToolbarItem(placement: .topBarTrailing) {
                    Button{
                        showAddActivityView = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .buttonStyle(PlainButtonStyle())
                    //.foregroundStyle(.black)
                    .sheet(isPresented: $showAddActivityView){
                        AddActivityView(currentActivities: $currentActivities)
                    }
                }
            }
            .navigationTitle("Your Activities")
            .navigationDestination(for: Activity.self, destination: { userActivity in
                if let index = currentActivities.firstIndex(where: {$0.id == userActivity.id}){
                    ActivityView(activity: $currentActivities[index], currentActivities: $currentActivities)
                }
            })
        }
        //.accentColor(.black)
    }
}



func loadUserActivities() -> [Activity] {
    guard let data = UserDefaults.standard.data(forKey: "userActivities"),
          let activities = try? JSONDecoder().decode([Activity].self, from: data)
    else {
        return []
    }
    
    return activities
}

#Preview {
    HomeView()
}
