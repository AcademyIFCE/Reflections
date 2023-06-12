//
//  EmptyReflectionViewController.swift
//  Reflections
//
//  Created by Gabriela Bezerra on 11/06/23.
//

import Foundation
import UIKit
import SwiftUI

class EmptyReflectionViewController: UIHostingController<EmptyReflectionView> {
    init() {
        super.init(rootView: EmptyReflectionView())
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        nil
    }
}

struct EmptyReflectionView: View {
    
    @State var yoffset: CGFloat = 0
    
    var body: some View {
        VStack(spacing: 20) {
            HStack(alignment: .top) {
                HStack {
                    Image(systemName: "bird.fill")
                        .font(.system(size: 30))
                        .offset(y: yoffset+10)
                        .foregroundColor(.cyan)
                    Image(systemName: "bird.fill")
                        .font(.system(size: 30))
                        .offset(y: -yoffset+20)
                        .foregroundColor(.white)
                    Image(systemName: "bird.fill")
                        .font(.system(size: 30))
                        .offset(y: -yoffset * 0.5)
                        .foregroundColor(.orange)
                }
                Image(systemName: "tree")
                    .font(.system(size: 80))
                    .foregroundColor(.green)
                Image(systemName: "sun.max.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.yellow)
                    .offset(y: -40)
                    .rotationEffect(yoffset > 15 ? .degrees(.pi) : -.degrees(.pi))
            }
            Text("Clique no botão de + para criar uma nova reflection, ou acesse alguma da lista ao lado.")
        }
        .multilineTextAlignment(.center)
        .padding()
        .foregroundColor(.white)
        .onAppear {
            withAnimation(.easeIn(duration: 2).repeatForever(autoreverses: true)) {
                yoffset = 30
            }
        }
    }
    
}
