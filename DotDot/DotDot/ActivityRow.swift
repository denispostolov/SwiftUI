//
//  ActivityRow.swift
//  DotDot
//
//  Created by Denis Postolov on 14/05/25.
//

import SwiftUI

struct ActivityRow: View {
    let activity: Activity
    
    var body: some View {
        HStack{
            
            /*ZStack{
                Circle()
                    .fill(.blue)
                    .foregroundColor(activity.type.rawValue == "work" ? .indigo : .white)
                Text(activity.type.rawValue == "work" ? "💼" : "🚴")
                    .font(.system(size: 32))
            }
            .frame(width: 60, height: 60)*/
            Image("sportIcon")
                .resizable()
                .scaledToFit()
                .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)
                .padding()
            
            Spacer()
            
            VStack(alignment: .trailing){
                Text(activity.name)
                    .font(.title2)
                Text("Day streak: \(activity.dayStreak)")
                    .font(.caption)
            }
            
        }
    }
}
