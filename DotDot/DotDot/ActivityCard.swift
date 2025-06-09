//
//  ActivityCard.swift
//  DotDot
//
//  Created by Denis Postolov on 17/05/25.
//

import SwiftUI

struct ActivityCard: View {
    
    let activity: Activity
    
    var body: some View {
        VStack {
            Image(activity.type.rawValue.lowercased())
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .padding()
            
            
            VStack {
                Text(activity.name)
                    .font(.headline)
                    .foregroundStyle(.black)
                
                Text(activity.type.rawValue)
                    .font(.subheadline)
                    .foregroundStyle(.black)
                
                HStack {
                    Text("Day streak: ")
                        .font(.caption)
                        .foregroundStyle(.black)
                    
                    Text("\(activity.dayStreak)")
                        .font(.headline)
                        .foregroundStyle(.black)
                }
                
                
            }
            .padding(.vertical)
            .frame(maxWidth: .infinity)
            .background(.beige)
            .cornerRadius(10)
            
        }
        .clipShape(.rect(cornerRadius: 10))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(.beige))
    }
}




