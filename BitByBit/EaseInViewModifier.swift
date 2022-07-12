//
//  BlinkingModifier.swift
//  SpotifyBitDisplay
//
//  Created by Matthew Ernst on 7/1/22.
//

import SwiftUI

struct EaseInViewModifier: ViewModifier {
    
    let duration: Double
    @State private var blinking: Bool = false
    
    func body(content: Content) -> some View {
        content
            .opacity(blinking ? 1 : 0)
            .animation(.easeOut(duration: duration))
            .onAppear {
                withAnimation {
                    blinking = true
                }
            }
    }
}

extension View {
    func easeIn(duration: Double = 0.75) -> some View {
        modifier(EaseInViewModifier(duration: duration))
    }
}
