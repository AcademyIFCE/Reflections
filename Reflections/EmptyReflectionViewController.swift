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
                        .offset(y: yoffset)
                        .foregroundColor(.cyan)
                    Image(systemName: "bird.fill")
                        .font(.system(size: 30))
                        .offset(y: -yoffset)
                        .foregroundColor(.white)
                    Image(systemName: "bird.fill")
                        .font(.system(size: 30))
                        .offset(y: -yoffset * 0.1)
                        .foregroundColor(.pink)
                }
                Image(systemName: "tree")
                    .font(.system(size: 80))
                    .foregroundColor(.green)
                Image(systemName: "sun.max.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.yellow)
                    .offset(y: -50)
            }
            Text("Clique no botão de + para criar uma nova reflection, ou acesse uma das reflections existentes na sidebar ao lado.")
        }
        .multilineTextAlignment(.center)
        .padding()
        .foregroundColor(.white)
        .onAppear {
            withAnimation(.easeInOut(duration: 2)) {
                yoffset = 20
            }
        }
    }
    
}
