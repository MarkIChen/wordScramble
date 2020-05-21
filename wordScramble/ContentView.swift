//
//  ContentView.swift
//  wordScramble
//
//  Created by Mark Chen on 2020/5/8.
//  Copyright © 2020 Mark Chen. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State private var title = ""
    @State private var usedWords = [String]()
    @State private var newWord = ""
    @State private var rootWord = ""
    
    @State private var errorMessage = ""
    @State private var errorTitle = ""
    @State private var showError = false
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter your new word.", text: $newWord, onCommit: addNewWord).textFieldStyle(RoundedBorderTextFieldStyle()).padding().autocapitalization(.none)
                List(usedWords, id: \.self) {
                    Image(systemName: "\($0.count).circle")
                    Text($0)
                }
            }
            .navigationBarItems(trailing:
                Button(action: refreshGame) {
                    Image(systemName: "arrow.clockwise").foregroundColor(.black)
                }
            )
                .navigationBarTitle(rootWord)
                .onAppear(perform: startGame)
                .alert(isPresented: $showError) {
                    Alert(title: Text("\(self.errorTitle)"),
                          message: Text("\(self.errorMessage)"),
                          dismissButton: .default(Text("OK")))
            }
        }
    }
    
    func addNewWord() {
        let ans = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines
        )
        newWord = ""
        guard ans.count > 0 else {return}
        
        guard isOriginal(word: ans) else {
            wordEror(message: "Be more creative.",
                     title: "Word used already")
            return
        }
        
        guard isPossible(word: ans) else {
            wordEror(message: "Please check your word again.",
                     title: "Word not allowed")
            return
        }
        guard isReal(word: ans) else {
            wordEror(message: "Please improve your English",
                     title: "This is not a word!")
            return
        }
        usedWords.insert(ans, at: 0)
    }
    
    func startGame() {
        guard let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") else {
            fatalError("Could not load start.txt from bundle")
        }
        if let startWords = try? String(contentsOf: startWordsURL) {
            let allWords = startWords.components(separatedBy: "\n")
            rootWord = allWords.randomElement() ?? "silkworm"
            
        }
    }
    
    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        
        for char in word {
            if let index = tempWord.firstIndex(of: char) {
                tempWord.remove(at: index)
            } else {
                return false
            }
        }
        return true
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    func wordEror(message: String, title: String) {
        self.errorMessage = message
        self.errorTitle = title
        self.showError = true
    }
    
    func refreshGame(){
        startGame()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
