//
//  SwipeCardView.swift
//  WatchReflections Watch App
//
//  Created by Gabriela Bezerra on 16/06/23.
//

import SwiftUI

struct SwipeCardView: View {
    @State var scrollAmount: Double = 0
    @State var xOffset: Double = 0
    @State var correct: Bool? = false
    
    @State var rows: [String] = Range(1...5).map { "Row \($0)" }
    
    var body: some View {
        VStack {
            Text("Scroll: \(scrollAmount)")
            ZStack {
                ForEach(rows, id: \.self) { row in
                    Text(row)
                        .frame(width: 150, height: 100)
                        .border(.white)
                        .padding()
                        .background(
                            Color.gray
                                .overlay {
                                    if xOffset > 0, row == rows.last {
                                        Color.green.opacity(xOffset/100)
                                    } else if row == rows.last {
                                        Color.red.opacity(-xOffset/100)
                                    }
                                }
                        )
                        .cornerRadius(11)
                        .shadow(color: .black, radius: 3, x: 1, y: 1)
                        .offset(x: row == rows.last ? xOffset : (row == rows[rows.count - 2] ? 5 : 10))
                        .rotationEffect(row == rows.last ? .degrees(xOffset * 0.1) : (row == rows[rows.count - 2] ? .degrees(1) : .degrees(2)))
                }
                .offset(x: -5)
            }
            .focusable(true)
            .digitalCrownRotation(
                detent: $scrollAmount,
                from: -100,
                through: 100,
                by: 20,
                sensitivity: .medium,
                isContinuous: false,
                isHapticFeedbackEnabled: true,
                onChange: { crown in
                    guard !rows.isEmpty else { return }
                    withAnimation(.linear(duration: 0.5)) {
                        xOffset = crown.offset
                    }
                },
                onIdle: {
                    guard !rows.isEmpty else { return }
                    if xOffset >= 100 {
                        print("certo")
                        withAnimation(.easeOut(duration: 0.1)) {
                            rows.removeLast()
                            xOffset = 0
                            scrollAmount = 0
                        }
                    } else if xOffset <= -100 {
                        print("errado")
                        withAnimation(.easeOut(duration: 0.1)) {
                            rows.removeLast()
                            xOffset = 0
                            scrollAmount = 0
                        }
                    } else {
                        print("🤷‍♀️")
                    }
                }
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SwipeCardView()
    }
}
