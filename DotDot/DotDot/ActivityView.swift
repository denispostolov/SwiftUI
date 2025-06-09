//
//  ActivityView.swift
//  DotDot
//
//  Created by Denis Postolov on 14/05/25.
//

import SwiftUI

struct ActivityView: View {
    
    @Binding var activity: Activity
    @Binding var currentActivities: [Activity]
    @State private var streakHasBeenIncreased = false
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.editMode) private var editMode
    
    var body: some View {
        ZStack{
            RadialGradient(stops: [
                .init(color: .beige, location: 0.3), .init(color: .white, location: 0.3)], center: .top, startRadius: 200, endRadius: 450)
            .ignoresSafeArea()
            
            VStack{
                HStack {
                    Image(activity.type.rawValue.lowercased())
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100, alignment: .leading)
                        .padding()
                    
                    
                    VStack(alignment: .leading){
                        Text(activity.name)
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.bottom, 10)
                        
                        Text(activity.type.rawValue)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                }
                .padding(.bottom, 20)
                
                ScrollView {
                    VStack(alignment: .center) {
                        Text("Description")
                            .font(.title2)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.bottom, 20)
                        
                        if(editMode?.wrappedValue.isEditing == true){
                            TextField("Activity Description", text: $activity.description)
                                .padding(10)
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(style: StrokeStyle(lineWidth: 1)))
                                .padding(.vertical, 20)
                        } else {
                            Text(activity.description)
                                .italic()
                                .padding(.bottom, 20)
                        }
                    }
                    .animation(nil, value: editMode?.wrappedValue)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    
                    
                    VStack(alignment: .center){
                        Text("Day streak")
                            .font(.title2)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.bottom, 20)
                        Text("\(activity.dayStreak)")
                            .italic()
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.bottom, 20)
                        
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    
                    Button {
                        updateActivity() 
                    } label: {
                        Text("Increase streak")
                            .font(.title3)
                            .fontWeight(.bold)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(streakHasBeenIncreased ? .gray.opacity(0.3) : .black)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .foregroundStyle(.white)
                    .shadow(radius: 2)
                    .padding(.horizontal)
                    .padding(.vertical, 40)
                    .disabled(streakHasBeenIncreased)
                    
                    Button("Delete Activity") {
                        deleteActivity()
                    }
                    .foregroundStyle(.red)
                }
                .frame(maxWidth: .infinity)
                .padding(40)
                .onChange(of: editMode?.wrappedValue){ oldMode, newMode in
                    if oldMode?.isEditing == true && newMode?.isEditing == false {
                        // Edit mode was turned off so let's save the changes
                        editActivity()
                    }
                }
                
            }
            
            .toolbar{
                EditButton()
            }
            
        }
    }
    
    private func editActivity(){
        if let index = currentActivities.firstIndex(where: {$0.id == activity.id}) {
            // update the activity in the list of all activities
            currentActivities[index] = activity
            
            if let encode = try? JSONEncoder().encode(currentActivities) {
                UserDefaults.standard.set(encode, forKey: "userActivities")
            }
        }
    }
    
    private func updateActivity() {
        activity.dayStreak += 1
        streakHasBeenIncreased = true
        
        editActivity()
        
    }
    
    
    private func deleteActivity(){
        if let index = currentActivities.firstIndex(where: {$0.id == activity.id}) {
            currentActivities.remove(at: index)
        }
        
        if let encode = try? JSONEncoder().encode(currentActivities){
            UserDefaults.standard.set(encode, forKey: "userActivities")
        }
        
        dismiss()
    }
}
