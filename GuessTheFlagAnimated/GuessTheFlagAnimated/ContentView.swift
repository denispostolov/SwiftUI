//
//  ContentView.swift
//  GuessTheFlagAnimated
//
//  Created by Denis Postolov on 02/02/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "USA"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var currentScore = 0
    @State private var selectedCountry = 0
    // The game has 8 rounds
    @State private var round = 1
    @State private var endGame = false
    // Animation challenges
    @State private var rotationAmounts : [Double] = Array(repeating: 0, count: 3)
    @State private var opacityAmounts : [Double] = Array(repeating: 1.0, count: 3)
    @State private var scaleAmounts: [Double] = Array(repeating: 1.0, count: 3)
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                Text("Guess The Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                Spacer()
                VStack(spacing: 15){
                    VStack {
                        Text("Tap the flag of")
                            .foregroundColor(.white)
                            .font(.subheadline.weight(.semibold))
                        Text(countries[correctAnswer])
                            .foregroundColor(.white)
                            .font(.largeTitle.weight(.heavy))
                        Spacer()
                    }
                    
                    HStack {
                        Text("Score: \(currentScore)")
                            .font(.title2.bold())
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("Round: \(round)")
                            .font(.title2.bold())
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    
                    Spacer()
                    Spacer()
                    Spacer()
                    ForEach(0..<3){ number in
                        Button {
                            flagTapped(number)
                        } label: {
                            Image(countries[number])
                                .renderingMode(.original)
                                .clipShape(RoundedRectangle(cornerRadius: 30))
                                .shadow(radius: 15)
                        }
                        .rotation3DEffect(
                            .degrees(rotationAmounts[number]),
                            axis: (x: 0.0, y: 1.0, z: 0.0)
                        )
                        .opacity(opacityAmounts[number])
                        .scaleEffect(scaleAmounts[number])
                        .animation(.easeOut(duration: 1), value: scaleAmounts[number])
                    }
                }
            }
            .padding()
            
        }
        .alert(scoreTitle, isPresented: $showingScore){
            Button("Continue", action: continueGame)
        } message: {
            scoreTitle == "Correct!" ? Text("You gain 10 points 🎉") : Text("That's the flag of \(countries[selectedCountry]) ☹️")
        }
        .alert("Game Ended", isPresented: $endGame){
            Button("Play Again", action: restartGame)
        } message: {
            currentScore == 80 ? Text("Your final result is: \(currentScore)/80. \n Awesome! 😍"): currentScore > 50 ? Text("Your final result is: \(currentScore)/80. \n Well Done! 👍🏻") : Text("Your final result is: \(currentScore)/80. \n Try Harder! 😭")
            
        }
        
    }
    
    // handling alert
    func flagTapped(_ number: Int){
        if number == correctAnswer{
            scoreTitle = "Correct!"
            currentScore += 10
        } else {
            scoreTitle = "Wrong!"
            
            if currentScore > 0 {
                currentScore -= 10
            } else {
                currentScore = 0
            }
            selectedCountry = number
            
        }
        
        showingScore = true
        
        // handling animation
        withAnimation {
            rotationAmounts[number] += 360
            scaleAmounts[number] = 1.5
            for index in 0..<opacityAmounts.count {
                if index != number {
                    opacityAmounts[index] = 0.25
                    scaleAmounts[index] = 0.5
                }
            }
        }
    }
    
    // Continue the game
    func continueGame() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        if round < 8 {
            round += 1
            resetOpacityAndScaleAmounts()
        } else {
            endGame = true
        }
    }
    
    // Restart the game
    func restartGame(){
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        currentScore = 0
        round = 1
    }
    
    func resetOpacityAndScaleAmounts(){
        opacityAmounts = Array(repeating: 1.0, count: 3)
        scaleAmounts = Array(repeating: 1.0, count: 3)
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

