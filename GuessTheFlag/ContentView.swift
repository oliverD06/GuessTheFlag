//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Oliver Delaney on 9/11/23.
//

import SwiftUI

struct FlagImage: View {
    var name: String

    var body: some View {
        Image(name)
            .renderingMode(.original)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
            .shadow(color: .black, radius: 2)
    }
}



struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()

    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var scoreTitle = ""
    @State private var score = 0

   
    @State private var spinAnimationAmounts = [0.0, 0.0, 0.0]
    @State private var animatingIncreaseScore = false

    
    @State private var shakeAnimationAmounts = [0, 0, 0]
    @State private var animatingDecreaseScore = false

    
    @State var animateOpacity = false

    @State private var wrongCountry = ""

    @State private var allowSubmitAnswer = true

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)

            VStack(spacing: 30) {
                VStack {
                    Text("Find the flag of")
                        .foregroundColor(.white)

                    // additional HStack with Spacers forces
                    // VStack to take full width, avoiding
                    // truncating country text
                    HStack {
                        Spacer()

                        Text(countries[correctAnswer])
                            .foregroundColor(.white)
                            .font(.largeTitle)
                            .fontWeight(.black)

                        Spacer()
                    }
                }

                ForEach(0 ..< 3) { number in
                    FlagImage(name: self.countries[number])
                        
                        .rotation3DEffect(.degrees(self.spinAnimationAmounts[number]), axis: (x: 0, y: 1, z: 0))
                        
                        
                        .opacity(self.animateOpacity ? (number == self.correctAnswer ? 1 : 0.25) : 1)
                        .onTapGesture {
                            self.flagTapped(number)
                        }
                }

                HStack {
                    Spacer()

                    Text("Score")
                        .foregroundColor(.white)

                    ZStack {
                        
                        Text("\(score)")
                            .foregroundColor(animatingIncreaseScore ? .green : (animatingDecreaseScore ? .red : .white))
                            .font(.title)

                       
                        Text("+1")
                            .font(.headline)
                            .foregroundColor(animatingIncreaseScore ? .green : .clear)
                            .opacity(animatingIncreaseScore ? 0 : 1)
                            .offset(x: 0, y: animatingIncreaseScore ? -50 : -20)

                       
                        Text("-1")
                            .foregroundColor(animatingDecreaseScore ? .red : .clear)
                            .font(.headline)
                            .opacity(animatingDecreaseScore ? 0 : 1)
                            .offset(x: 0, y: animatingDecreaseScore ? 50 : 20)
                    }

                    Spacer()
                }
                .offset(x: 0, y: 30)

                Spacer()

                
                Text("That was \(wrongCountry)")
                    .font(.headline)
                    .foregroundColor(animatingDecreaseScore ? .red : .clear)
            }
        }
    }

    func flagTapped(_ number: Int) {
      
        guard allowSubmitAnswer else { return }
        allowSubmitAnswer = false

       
        let nextQuestionDelay = 1.5
        let flagAnimationDuration = 0.5
        let scoreUpdateDuration = 1.5

        
        withAnimation(Animation.easeInOut(duration: flagAnimationDuration)) {
            self.animateOpacity = true
        }

        if number == correctAnswer {
            score += 1
          
            withAnimation(Animation.easeInOut(duration: flagAnimationDuration)) {
                self.spinAnimationAmounts[number] += 360
            }
            withAnimation(Animation.linear(duration: scoreUpdateDuration)) {
                self.animatingIncreaseScore = true
            }
        }
        else {
            wrongCountry = countries[number]
            score -= 1
       
            withAnimation(Animation.easeInOut(duration: flagAnimationDuration)) {
                self.shakeAnimationAmounts[number] = 2
            }
            withAnimation(Animation.linear(duration: scoreUpdateDuration)) {
                self.animatingDecreaseScore = true
            }
        }

     
        DispatchQueue.main.asyncAfter(deadline: .now() + nextQuestionDelay) {
            self.askQuestion()
        }
    }

    func askQuestion() {
     
        self.spinAnimationAmounts = [0.0, 0.0, 0.0]
        self.animatingIncreaseScore = false
    
        self.animateOpacity = false
        
        self.shakeAnimationAmounts = [0, 0, 0]
        self.animatingDecreaseScore = false

        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)

        
        allowSubmitAnswer = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
