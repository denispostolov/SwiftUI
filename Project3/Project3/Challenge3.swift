//
//  Challenge3.swift
//  Project3
//
//  Created by Denis Postolov on 11/09/23.
//

import SwiftUI

extension View {
    func blueTitle() -> some View {
        modifier(BlueTitleModifier())
    }
}

struct Challenge3: View {
    var body: some View {
        Text("Hello World!")
            .blueTitle()
            .padding()
    }
}

struct Challenge3_Previews: PreviewProvider {
    static var previews: some View{
        Challenge3()
    }
}

// Challenge 3: Create a ViewModifier (with a View extension) that makes a View have large, blue font suitable for prominent titles in view
struct BlueTitleModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.blue)
    }
}
