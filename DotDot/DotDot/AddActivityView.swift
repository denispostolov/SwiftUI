//
//  AddActivityView.swift
//  DotDot
//
//  Created by Denis Postolov on 27/05/25.
//

import SwiftUI

struct AddActivityView: View {
    
    //@Binding var showingSheet: Bool
    @Binding var currentActivities: [Activity]
    
    @State private var selectedType: ActivityType = .personal
    @State private var activityName = ""
    @State private var activityDescription = ""
    
    @Environment(\.dismiss) private var dismiss
    
    
    var body: some View {
        NavigationStack{
            VStack {
                TabView(selection: $selectedType){
                    ForEach(ActivityType.allCases, id: \.self){ activityType in
                        VStack{
                            Image(activityType.rawValue.lowercased())
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                            
                            Text(activityType.rawValue)
                                .font(.title2)
                                .bold()
                                .padding(.vertical, 20)
                        }
                        .tag(activityType)
                    }
                }
                .tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                .frame(height: 450)
                
                TextField("Activity Name", text: $activityName)
                    .textFieldStyle(.roundedBorder)
                    .padding(.top, 20)
                    .padding(.horizontal)
                
                TextField("Activity Description", text: $activityDescription)
                    .textFieldStyle(.roundedBorder)
                    .padding(.top, 20)
                    .padding(.horizontal)
                
                Spacer()
            }
            .navigationTitle("New Activity")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing){
                    Button("Save"){
                        saveActivity()
                        //showingSheet = false
                    }
                    //.foregroundStyle(.black)
                }
                
                ToolbarItem(placement: .cancellationAction){
                    Button("Cancel"){
                        dismiss()
                        //showingSheet = false
                    }
                    .foregroundStyle(.red)
                }
            }
        }
    }
    
    func saveActivity(){
        let newActivity = Activity(
            name: activityName,
            type: selectedType,
            description: activityDescription
        )
        
        currentActivities.append(newActivity)
        if let encoded = try? JSONEncoder().encode(currentActivities){
            UserDefaults.standard.set(encoded, forKey: "userActivities")
        }
        dismiss()
    }
}
