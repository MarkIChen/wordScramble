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
    @State private var usedNames = [String]()
    @State private var newWord = ""
    
    var body: some View {
       
        NavigationView {
            VStack {
                TextField("Enter your new word.", text: $newWord, onCommit: addNewWord).textFieldStyle(RoundedBorderTextFieldStyle()).padding().autocapitalization(.none)
                List(usedNames, id: \.self) {
                    Text($0)
                }
            }
        }
        
       
    }
    
    func addNewWord() {
        let ans = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines
        )
        newWord = ""
        guard ans.count > 0 else {return}
        usedNames.insert(ans, at: 0)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
