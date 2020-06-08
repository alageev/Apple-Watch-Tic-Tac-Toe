//
//  ContentView.swift
//  tic-tac-toe WatchKit Extension
//
//  Created by Алексей Агеев on 07.06.2020.
//  Copyright © 2020 Alexey Ageev. All rights reserved.
//

import SwiftUI

enum press: UInt8 {
    case nobody = 0
    case player = 1
    case computer = 2
}

struct ContentView: View {
    @State var playerFirst : Bool = true
    @State var cells : [[press]] = [
        [.nobody, .nobody, .nobody],
        [.nobody, .nobody, .nobody],
        [.nobody, .nobody, .nobody]
    ]
    @State var winner : press = .nobody
    @State var alertIsVisible = false
    
    var body: some View {
        VStack {
            ForEach(0...2, id: \.self){ i in
                HStack {
                    ForEach(0...2, id: \.self){ j in
                        Button(action: {
                            if (self.cells[i][j] == .nobody){
                                self.cells[i][j] = .player
                                self.check()
                                if !self.alertIsVisible {
                                    self.move()
                                    self.check()
                                }
                            }
                        }) {
                            if self.cells[i][j] == .nobody {
                                Text("")
                            } else if self.cells[i][j] == .player {
                                if self.playerFirst {
                                    Text("✕")
                                } else {
                                    Text("○")
                                }
                            } else {
                                if self.playerFirst {
                                    Text("○")
                                } else {
                                    Text("✕")
                                }
                            }
                        }
                        .alert(isPresented: self.$alertIsVisible) {
                            var winner : String
                            if self.winner == .player {
                                winner = "You win!"
                                WKInterfaceDevice().play(.success)
                            } else if self.winner == .computer {
                                winner = "Computer wins!"
                                WKInterfaceDevice().play(.failure)
                            } else {
                                winner = "Tie!"
                                WKInterfaceDevice().play(.retry)
                            }
                            return Alert(title: Text(winner), message: Text("New game?"), dismissButton: .default(Text("Sure!")){
                                self.winner = .nobody
                                for i in 0...2 {
                                    for j in 0...2 {
                                        self.cells[i][j] = .nobody
                                    }
                                }
                            })
                        }
                    }
                }
            }
        }
        .onAppear(perform: {
            self.playerFirst = Bool.random()
            if !self.playerFirst {
                self.move()
            }
        })
        .navigationBarTitle("Tic Tac Toe")
    }
    
    func check () {
        var fieldIsFull = true
        for i in 0...2 {
            for j in 0...2 {
                if cells[i][j] == .nobody {
                    fieldIsFull = false
                    break
                }
            }
        }
        if fieldIsFull {
            winner = .nobody
            alertIsVisible = true
            return
        }
        
        for i in 0...2 {
            if cells[i][0] != .nobody && cells[i][0] == cells[i][1] && cells[i][1] == cells[i][2] {
                winner = cells[i][0]
                alertIsVisible = true
                return
            }
            if cells[0][i] != .nobody && cells[0][i] == cells[1][i] && cells[1][i] == cells[2][i] {
                winner = cells[0][i]
                alertIsVisible = true
                return
            }
        }
        if cells[0][0] != .nobody && cells[0][0] == cells[1][1] && cells[1][1] == cells[2][2] {
            winner = cells[0][0]
            alertIsVisible = true
            return
        }
        if cells[0][2] != .nobody && cells[0][2] == cells[1][1] && cells[1][1] == cells[2][0] {
            winner = cells[0][2]
            alertIsVisible = true
            return
        }
    }
    
    func move () {
        var placesToStop: [[UInt8]] = []
        for i in 0...2 {
            //checking rows
            if cells[i][2] == .nobody && cells[i][0] != .nobody && cells[i][0] == cells[i][1] {
                if cells[i][0] == .computer {
                    cells[i][2] = .computer
                    return
                } else {
                    placesToStop.append([UInt8(i), 2])
                }
            }
            if cells[i][1] == .nobody && cells[i][0] != .nobody && cells[i][0] == cells[i][2] {
                if cells[i][0] == .computer {
                    cells[i][1] = .computer
                    return
                } else {
                    placesToStop.append([UInt8(i), 1])
                }
            }
            if cells[i][0] == .nobody && cells[i][1] != .nobody && cells[i][1] == cells[i][2] {
                if cells[i][1] == .computer {
                    cells[i][0] = .computer
                    return
                } else {
                    placesToStop.append([UInt8(i), 0])
                }
            }
            
            //checking columns
            if cells[2][i] == .nobody && cells[0][i] != .nobody && cells[0][i] == cells[1][i] {
                if cells[0][i] == .computer {
                    cells[2][i] = .computer
                    return
                } else {
                    placesToStop.append([2, UInt8(i)])
                }
            }
            if cells[1][i] == .nobody && cells[0][i] != .nobody && cells[0][i] == cells[2][i] {
                if cells[0][i] == .computer {
                    cells[1][i] = .computer
                    return
                } else {
                    placesToStop.append([1, UInt8(i)])
                }
            }
            if cells[0][i] == .nobody && cells[1][i] != .nobody && cells[1][i] == cells[2][i] {
                if cells[1][i] == .computer {
                    cells[0][i] = .computer
                    return
                } else {
                    placesToStop.append([0, UInt8(i)])
                }
            }
        }
        //checking main diagonal
        if cells[2][2] == .nobody && cells[0][0] != .nobody && cells[0][0] == cells[1][1] {
            if cells[0][0] == .computer {
                cells[2][2] = .computer
                return
            } else {
                placesToStop.append([2, 2])
            }
        }
        if cells[1][1] == .nobody && cells[0][0] != .nobody && cells[0][0] == cells[2][2] {
            if cells[0][0] == .computer {
                cells[1][1] = .computer
                return
            } else {
                placesToStop.append([1, 1])
            }
        }
        if cells[0][0] == .nobody && cells[1][1] != .nobody && cells[1][1] == cells[2][2] {
            if cells[1][1] == .computer {
                cells[0][0] = .computer
                return
            } else {
                placesToStop.append([0, 0])
            }
        }
        //checking another diagonal
        if cells[2][0] == .nobody && cells[0][2] != .nobody && cells[0][2] == cells[1][1] {
            if cells[0][2] == .computer {
                cells[2][0] = .computer
                return
            } else {
                placesToStop.append([2, 0])
            }
        }
        if cells[1][1] == .nobody && cells[0][2] != .nobody && cells[0][2] == cells[2][0] {
            if cells[0][2] == .computer {
                cells[1][1] = .computer
                return
            } else {
                placesToStop.append([1, 1])
            }
        }
        if cells[0][2] == .nobody && cells[1][1] != .nobody && cells[1][1] == cells[2][0] {
            if cells[1][1] == .computer {
                cells[0][2] = .computer
                return
            } else {
                placesToStop.append([0, 2])
            }
        }
        
        if placesToStop.count > 0 {
            cells[Int(placesToStop[0][0])][Int(placesToStop[0][1])] = .computer
            return
        }
        
        var computerMoved = false
        
        while !computerMoved {
            let row = Int.random(in: 0...2)
            let col = Int.random(in: 0...2)
            if cells[row][col] == .nobody {
                computerMoved = true
                cells[row][col] = .computer
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView().previewDevice("Apple Watch Series 2 - 38mm")
            ContentView().previewDevice("Apple Watch Series 2 - 42mm")
            ContentView().previewDevice("Apple Watch Series 4 - 40mm")
            ContentView().previewDevice("Apple Watch Series 4 - 44mm")
        }
    }
}
