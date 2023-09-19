//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Denis Postolov on 13/09/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var currentChoice = Int.random(in: 0...2)
    @State private var gameResult = Int.random(in: 0...2)
    // +1 if the player has correctly answered, -1 otherwise.
    @State private var currentScore = 0
    // There are 10 rounds
    @State private var round = 1
    // Show if the play has answered in a correct way or not
    @State private var answer = ""
    
    @State private var moves = ["Rock", "Paper", "Scissors"].shuffled()
    // I didn't use a boolean because I want also a tie as a possible result
    @State private var results = ["Win", "Lose", "Tie"].shuffled()
    
    @State private var endGame = false
    // State variable to display suitable text
    @State private var moveTapped = false
    
    
    var body: some View {
        ZStack{
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.4, blue: 0.5), location: 0.3),
                .init(color: Color(red: 0.9, green: 0.6, blue: 0.5), location: 0.3)], center: .bottom, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            
            VStack{
                Spacer()
                Text("Rock, Paper & Scissors")
                    .font(.custom("AmericanTypeWriter", fixedSize: 32).weight(.bold))
                Spacer()
                VStack(spacing: 70){
                    Image(moves[currentChoice])
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.black, lineWidth: 2))
                        .shadow(radius: 5)
                    
                    HStack{
                        
                        VStack(spacing: 10){
                            Text("You have to:")
                            Text("\(results[gameResult])")
                                .font(.title.bold())
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        VStack(spacing: 10){
                            Text("Round: \(round)/10")
                                .font(.title2)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                            Text("Score: \(currentScore)")
                                .font(.title2.bold())
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                    }
                }
                Spacer()
                Spacer()
                VStack {
                    if moveTapped {
                        Text(answer)
                            .font(.title2.italic())
                            .onTapGesture {
                            continueGame()
                        }
                    } else {
                        BouncingText(text: "Select you choice", startTime: 0.0)
                    }
                    
                }
                Spacer()
                HStack{
                    ForEach(0..<3){ number in
                        Button {
                            onMoveTapped(number)
                        } label: {
                            Image(moves[number])
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.black, lineWidth: 2))
                                .shadow(radius: 5)
                        }
                    }
                }
                Spacer()
            }
        }
        .alert("Game Ended", isPresented: $endGame){
            Button("Play Again", action: restartGame)
        } message: {
            currentScore == 10 ? Text("Your final result is: \(currentScore)/10. \n Awesome! 😍"): currentScore > 5 ? Text("Your final result is: \(currentScore)/10. \n Well Done! 👍🏻") : Text("Your final result is: \(currentScore)/10. \n Try Harder! 😭")
            
        }
        
    }
    
    func onMoveTapped(_ number: Int) {
        moveTapped = true
        if(results[gameResult] == "Win"){
            if(moves[currentChoice] == "Rock"){
                if(moves[number] == "Paper"){
                    answer = "Correct!"
                    currentScore += 1
                }
                else {
                    answer = "Wrong..."
                    decreaseScore()
                }
            } else if(moves[currentChoice] == "Paper"){
                if(moves[number] == "Scissors"){
                    answer = "Correct!"
                    currentScore += 1
                } else {
                    answer = "Wrong..."
                    decreaseScore()
                }
            } else if(moves[currentChoice] == "Scissors"){
                if(moves[number] == "Rock"){
                    answer = "Correct!"
                    currentScore += 1
                } else {
                    answer = "Wrong..."
                    decreaseScore()
                }
            }
        } else if(results[gameResult] == "Lose"){
            if(moves[currentChoice] == "Rock"){
                if(moves[number] == "Scissors"){
                    answer = "Correct!"
                    currentScore += 1
                }
                else {
                    answer = "Wrong..."
                    decreaseScore()
                }
            } else if(moves[currentChoice] == "Paper"){
                if(moves[number] == "Rock"){
                    answer = "Correct!"
                    currentScore += 1
                } else {
                    answer = "Wrong..."
                    decreaseScore()
                }
            } else if(moves[currentChoice] == "Scissors"){
                if(moves[number] == "Paper"){
                    answer = "Correct!"
                    currentScore += 1
                } else {
                    answer = "Wrong..."
                    decreaseScore()
                }
            }
        } else if(results[gameResult] == "Tie"){
            if(moves[currentChoice] == moves[number]){
                answer = "Correct!"
                currentScore += 1
            } else {
                answer = "Wrong..."
                decreaseScore()
            }
        }
        
    }
   
    func decreaseScore() {
        if(self.currentScore > 0){
            self.currentScore -= 1
        } else {
            self.currentScore = 0
        }
        
    }
    
    func continueGame() {
        moves.shuffle()
        results.shuffle()
        currentChoice = Int.random(in: 0...2)
        answer = ""
        moveTapped = false
        if round < 10 {
            round += 1
        } else {
            endGame = true
        }
    }
    
    func restartGame(){
        moves.shuffle()
        results.shuffle()
        currentChoice = Int.random(in: 0...2)
        currentScore = 0
        round = 1
        moveTapped = false
    }
    
}


// View to show a text with a bouncing effect
struct BouncingText: View {
    let characters: Array<String.Element>
    
    @State var offsetYForBounce: CGFloat = -50
    @State var opacity: CGFloat = 0
    @State var baseTime: Double
    
    init(text: String, startTime: Double){
        self.characters = Array(text)
        self.baseTime = startTime
    }
    
    var body: some View {
        HStack{
            ForEach(0..<characters.count, id:\.self) { num in
                let _ = print(self.characters[num])
                Text(String(self.characters[num]))
                    .font(.title2.italic())
                    .offset(x: 0.0, y: offsetYForBounce)
                    .opacity(opacity)
                    .animation(.spring(response: 0.2, dampingFraction: 0.5, blendDuration: 0.1).delay( Double(num) * 0.1 ), value: offsetYForBounce)
            }
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + (0.8 + baseTime)) {
                    opacity = 1
                    offsetYForBounce = 0
                }
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
