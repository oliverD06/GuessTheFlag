//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Oliver Delaney on 9/11/23.
//

import SwiftUI

struct ContentView: View {
    @State private var showingScore = false
    @State private var restartGame = false
    @State private var finalScore = ""
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var loop = 1
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    
    @State private var correctAnswer = Int.random(in: 0...2)
    
    
    
    
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.1, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            VStack {
                Spacer()
                
                Text("Guess The Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                        
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button{
                            flagTapped(number)
                        } label: {
                            Image(countries[number])
                                .renderingMode(.original)
                                .clipShape(Capsule())
                                .shadow(radius: 5)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            if loop != 8 {
                Button("Continue", action: askQuestion)
            }
            else {
                Button("Restart", action: initRestart)
            }
        } message: {
            if loop != 8 {
                Text("Your score is \(score)")
            }else {
                Text("You got \(score)/8 correct!")
            }
            
        }
        
    }
    
    func flagTapped(_ number: Int) -> Int {
        if number == correctAnswer {
            scoreTitle = "Correct"
            score = score + 1
        }else {
            
            scoreTitle = "Wrong! That's the flag of \(countries[number])"
        }
        showingScore = true
        return score
    }
    
    func askQuestion() {
        
            countries.shuffle()
            correctAnswer = Int.random(in: 0...2)
        loop = loop + 1
            
        
    }
   
    func initRestart() {
        countries.shuffle()
                correctAnswer = Int.random(in: 0...2)
                loop = 1
                score = 0
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
