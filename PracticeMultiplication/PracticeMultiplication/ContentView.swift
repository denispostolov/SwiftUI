//
//  ContentView.swift
//  PracticeMultiplication
//
//  Created by Denis Postolov on 05/02/24.
//

import SwiftUI

// Radio button used in SettingsView
struct SquareButton: View {
    
    @Binding var value: Bool
    var text: String
    
    var body: some View {
        Button {
            value.toggle()
        } label: {
            HStack(spacing: 1) {
                Image(systemName: value ? "checkmark" : "square")
                    .colorMultiply(.black)
                Text(text)
                    .colorMultiply(.black)
            }
        }
        
    }
}

struct ContentView: View {
    
    @State private var homeButtonsTapped: [Bool] = Array(repeating: false, count: 2)
    @State private var isVisible = false
    @State private var numberOfQuestions: Int = 5
    // To get the real value of the multiplication table, +2 is needed
    @State private var multiplicationTableIndex: Int = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                RadialGradient(stops: [
                    .init(color: Color(red: 0, green: 0.55, blue: 0.8), location: 0.6),
                    .init(color: Color(red: 1, green: 1, blue: 1), location: 0.3)], center: .bottom, startRadius: 100, endRadius: 700)
                    .ignoresSafeArea()
                
                Spacer()
                
                
                VStack{
                    
                    Spacer()
                    
                    Text("Practice Multiplication")
                        .font(.largeTitle).bold()
                        .kerning(4.0)
                        .foregroundStyle(.indigo)
                        .padding(14.5)
                        
                    
                    Image("Multiplication")
                        .resizable()
                            .frame(width: 150, height: 150)
                    
                    Spacer()
                    Spacer()
                    
                    Button("Play"){
                        homeButtonsTapped[0].toggle()
                    }
                    .padding(30)
                    .frame(width: 200, height: 70)
                    .foregroundColor(.white)
                    .font(.title2).bold()
                    .background(.green)
                    .clipShape(.capsule)
                    .shadow(radius: 5)
                    .navigationDestination(isPresented: $homeButtonsTapped[0]){
                        GameView(multiplicationTableIndex: $multiplicationTableIndex, numberOfQuestions: $numberOfQuestions)
                            .navigationBarBackButtonHidden(true)
                    }
                    
                    Button("Settings"){
                        homeButtonsTapped[1].toggle()
                    }
                    .padding(30)
                    .frame(width: 200, height: 70)
                    .foregroundColor(.white)
                    .font(.title2).bold()
                    .background(.orange)
                    .clipShape(.capsule)
                    .shadow(radius: 5)
                    .navigationDestination(isPresented: $homeButtonsTapped[1]){
                        SettingsView(numberOfQuestions: $numberOfQuestions, multiplicationTableIndex: $multiplicationTableIndex)
                    }
                    
                    
                    Spacer()
                    Spacer()
                }
                
            }
        }
    }
}

struct GameView: View {
    
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var currentScore = 0
    @State private var showingScore = false
    @State private var selectedAnswer = 0
    @State private var feedback = ""
    // Timer for each rounds
    @State private var remainingTime = 10
    @State private var timer: Timer?
    // The game has numberOfQuestions rounds
    @State private var round = 1
    @State private var endGame = false
    // Go Home alert's button pressed
    @State private var homeButtonPressed = false
    
    // variables passed across the views
    @Binding var multiplicationTableIndex: Int
    @Binding var numberOfQuestions: Int
    
    // for dismissing this view when the user wants to stop playing
    @Environment(\.presentationMode) var presentationMode
    
    private let multiplicationTables = [2: [0,2,4,6,8,10,12,14,16,18,20],
                                        3: [0,3,6,9,12,15,18,21,24,27,30],
                                        4: [0,4,8,12,16,20,24,28,32,36,40],
                                        5: [0,5,10,15,20,25,30,35,40,45,50],
                                        6: [0,6,12,18,24,30,36,42,48,54,60],
                                        7: [0,7,14,21,28,35,42,49,56,63,70],
                                        8: [0,8,16,24,32,40,48,56,64,72,80],
                                        9: [0,9,18,27,36,45,54,63,72,81,90],
                                        10: [0,10,20,30,40,50,60,70,80,90,100],
                                        11: [0,11,22,33,44,55,66,77,88,99,110],
                                        12: [0,12,24,36,48,60,72,84,96,108,120]]
    
    @State private var currentMultiplicationTable = Array(repeating: 0, count: 11)
    
    // For animations
    @State private var scaleAmounts: [Double] = Array(repeating: 1.0, count: 3)
    
    var body: some View {
        ZStack{
            RadialGradient(stops: [
                .init(color: Color(red: 0.4, green: 0.85, blue: 0.4), location: 0.6),
                .init(color: Color(red: 1, green: 1, blue: 1), location: 0.3)], center: .bottom, startRadius: 100, endRadius: 700)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                Spacer()
                Text("Practise Multiplication")
                    .font(.largeTitle).bold()
                    .kerning(4.0)
                    .foregroundStyle(.green)
                    .padding(14.5)
                
                Spacer()
                
                VStack(spacing: 15){

                        Text("How much is \(multiplicationTableIndex + 2) x \(currentMultiplicationTable[correctAnswer] / (multiplicationTableIndex + 2)) ?")
                            .font(.title).bold()
                            .kerning(1.0)
                            .foregroundStyle(.black)
                            .padding(14.5)
                    
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                        
                    Text("Round: \(round)")
                        .font(.title2).bold()
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(20)
                    
                    if feedback != "" {
                        Text(feedback)
                            .font(.title2).italic()
                            .foregroundColor(feedback == "Correct! 🤩" ? .blue : .red)
                    } else {
                        Text("\(remainingTime)")
                            .font(.title2)
                            .onAppear {
                                // Start the timer when the view appears
                                timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                                        if remainingTime > 0 {
                                            remainingTime -= 1
                                        } else {
                                            // End game when timer runs out
                                            endGame = true
                                        }
                                }
                            }
                            .onDisappear {
                                // Invalidate the timer when the view disappears
                                    timer?.invalidate()
                            }
                    }
                    
                    Spacer()
                    
                    ForEach(0..<3){ number in
                        Button("\(currentMultiplicationTable[number])") {
                            resultButtonTapped(number)
                        }
                        .padding(30)
                        .frame(width: 200, height: 70)
                        .foregroundColor(.white)
                        .font(.title3).bold()
                        .background(.purple)
                        .clipShape(.capsule)
                        .shadow(radius: 5)
                        .scaleEffect(scaleAmounts[number])
                        .animation(.easeOut, value: scaleAmounts[number])
                    }
                    
                    Spacer()
                    Spacer()
                    
                }
            }
        }
        .onAppear {
            currentMultiplicationTable = multiplicationTables[(multiplicationTableIndex + 2)]!.shuffled()
        }
        .alert(isPresented: $endGame){
            Alert(
                title: Text("Game Ended"),
                message: Text("Rounds completed: \(round)/\(numberOfQuestions). \n" + "Correct answers: \(currentScore)/\(round)."),
                primaryButton: .destructive(Text("Go Home")){
                    // Dismissing this current view
                    presentationMode.wrappedValue.dismiss()
                },
                secondaryButton: .cancel(Text("Play Again")){
                    restartGame()
                }
            )
        }
    }
    
    
    func resultButtonTapped(_ number: Int){
        if number == correctAnswer{
            feedback = "Correct! 🤩"
            currentScore += 1
        } else {
            feedback = "Wrong 😕"
            selectedAnswer = number
        }
        
        // Invoking continueGame function after 1 sec
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            continueGame()
        }
        
        withAnimation {
            scaleAmounts[number] = 1.2
        }
        
    }
    
    func continueGame() {
        currentMultiplicationTable.shuffle()
        correctAnswer = Int.random(in: 0...2)
        feedback = ""
        remainingTime = 10
        if round < numberOfQuestions {
            round += 1
            resetScaleAmounts()
        } else {
            endGame = true
        }
    }
    
    func restartGame(){
        currentMultiplicationTable.shuffle()
        correctAnswer = Int.random(in: 0...2)
        feedback = ""
        remainingTime = 10
        currentScore = 0
        round = 1
        resetScaleAmounts()
    }
    
    func resetScaleAmounts(){
        scaleAmounts = Array(repeating: 1, count: 3)
    }
    
}

struct SettingsView: View {
    
    @State private var isOn: [Bool] = Array(repeating: false, count: 3)
    @Binding var numberOfQuestions: Int
    @Binding var multiplicationTableIndex: Int
    
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.9, green: 0.57, blue: 0), location: 0.6),
                .init(color: Color(red: 1, green: 1, blue: 1), location: 0.3)], center: .bottom, startRadius: 100, endRadius: 700)
                .ignoresSafeArea()
            
            VStack {
                Text("Settings")
                    .font(.largeTitle).bold()
                    .kerning(4.0)
                    .foregroundStyle(.orange)
                    .padding(14.5)
                
                Spacer()
                
                Text("How many questions do you want to answer?")
                    .font(.title2).bold()
                    .kerning(1.0)
                    .foregroundStyle(.black)
                    .padding(14.5)
                Text("* select only one value")
                    .font(.subheadline).bold()
                    .kerning(1.0)
                    .foregroundStyle(.red)
                
                Spacer()
                Spacer()
                
                HStack(spacing: 30){
                    ForEach(0..<3) { number in
                        SquareButton(value: $isOn[number], text: number == 0 ? "5" : number == 1 ? "10" : "20")
                    }
                }
                .onChange(of: isOn){
                    if isOn == [true, false, false] {
                        numberOfQuestions = 5
                    } else if isOn == [false, true, false] {
                        numberOfQuestions = 10
                    } else {
                        numberOfQuestions = 20
                    }
                }
                
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                
                Text("Of which multiplication table?")
                    .font(.title3).bold()
                    .foregroundStyle(.black)
                    .padding(14.5)
                
                Picker("Select a Multiplication Table", selection: $multiplicationTableIndex){
                        ForEach(2..<13){ number in
                            Text("\(number)")
                        }
                }
                .pickerStyle(.wheel)
                
                Spacer()
                Spacer()
                
                Text("You selected: \(multiplicationTableIndex + 2)")
                    .font(.subheadline).bold()
                
                
                Spacer()
                Spacer()
                
            }
        }
        .onAppear {
            if numberOfQuestions == 5 {
                isOn[0] = true
            } else if numberOfQuestions == 10 {
                isOn[1] = true
            } else {
                isOn[2] = true
            }
        }
        
    }
}

#Preview {
    ContentView()
}
