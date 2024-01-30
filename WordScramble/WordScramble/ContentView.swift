//
//  ContentView.swift
//  WordScramble
//
//  Created by Denis Postolov on 27/10/23.
//

import SwiftUI

struct GrowingButtonWhenTapped: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(.orange)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    @State private var score = 0
    // error/alert handling variables
    @State private var errorTitle = ""
    @State private var restartTitle = "Are you sure to restart the game?"
    @State private var disallowedWordTitle = "You can't use this word."
    @State private var errorMessage = ""
    @State private var showingError = false
    @State private var showingRestartAlert = false
    @State private var showingWordEqualToRootAlert = false
    @State private var showingWordTooShortAlert = false
    
    var body: some View {
        NavigationStack {
            List{
                Section{
                    TextField("Enter your word", text: $newWord)
                        .textInputAutocapitalization(.never)
                }
                Section {
                    ForEach(usedWords, id: \.self) { word in
                        HStack {
                            Image(systemName: "\(word.count).circle")
                            Text(word)
                        }
                    }
                }
            }
            .navigationTitle(rootWord)
            // Challenge 2: Add a toolbar button that calls startGame so users can restart the game with a new word whenever they want.
            .toolbar{
                Button("Restart"){
                    showingRestartAlert.toggle()
                }
                .buttonStyle(GrowingButtonWhenTapped())
            }
            .onSubmit(addNewWord)
            .onAppear(perform: startGame)
            .alert(errorTitle, isPresented: $showingError) {
                Button("OK"){}
            } message: {
                Text(errorMessage)
            }
            .alert(restartTitle, isPresented: $showingRestartAlert){
                Button("Yes, I'm sure", role: .destructive){
                    restartGame()
                }
            }
            .alert(disallowedWordTitle, isPresented: $showingWordEqualToRootAlert){
                Button("Ok, I'll try another one 🥺"){}
            } message: {
                Text("It seems that your word is equal to the start word. You can do better!")
            }
            .alert(disallowedWordTitle, isPresented: $showingWordTooShortAlert){
                Button("Ok, I'll try another one 🥺"){}
            } message: {
                Text("It seems that your word is too short. Search for words with more than 3 letters. You can do it!")
            }
            // Challenge 3: Put a text view somewhere do you can track and show the player's score (in my case, every correct word has a value of 1 point)
            Text("Score: \(score)")
                .font(.title).bold()
                .frame(maxWidth: .infinity, alignment: .center)
            
        }

    }
    
    // handle game dynamic
    func addNewWord() {
        
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard answer.count > 0 else { return }
        
        guard isWordUnused(word: answer) else {
            wordError(title: "Word used already", message: "Be more original")
            return
        }
        
        guard isWordPossible(word: answer) else {
            wordError(title: "Word not possible", message: "You can't spell that word from \(rootWord)!")
            return
        }
        
        guard isWordReal(word: answer) else {
            wordError(title: "Word not recognized", message: "You can't just make them up, you know!")
            return
        }
        
        guard !isAnswerDisallowed(word: answer) else { return }
        
        withAnimation {
            usedWords.insert(answer, at: 0)
        }
        // Challenge 3
        score += 1
        
        newWord = ""
    }
    
    // initialization of the game
    func startGame() {
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt"){
            if let startWords = try? String(contentsOf: startWordsURL){
                
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkworm"
                // everything worked, so we can exit
                return
            }
        }
        
        fatalError("Could not load start.txt from bundle.")
        
    }
    
    func isWordUnused(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    func isWordPossible(word: String) -> Bool {
        var tempWord = rootWord
        
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter){
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        
        return true
    }
    
    func isWordReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    func wordError(title: String, message: String){
        errorTitle = title
        errorMessage = message
        showingError = true
    }

    
    // Challenge 1: Disallow answers shorter than 3 letters or equal to start word
    func isAnswerDisallowed(word: String) -> Bool {
        if (word == rootWord){
            showingWordEqualToRootAlert.toggle()
            return true
        } else if(word.count <= 3){
            showingWordTooShortAlert.toggle()
            return true
        }
        
        return false
    }
    
    // Challenge 2
    func restartGame(){
        usedWords.removeAll()
        newWord = ""
        score = 0
        startGame()
    }
    
}

#Preview {
    ContentView()
}
