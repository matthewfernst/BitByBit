//
//  ContentView.swift
//  SpotifyBitDisplay
//
//  Created by Matthew Ernst on 6/6/22.
//

import SwiftUI

struct ContentView: View {
    let bitByBitColors: [Color] = [.red, .orange, .yellow, .green, .blue, .purple, .pink]
    @State var buttonsHidden = true
    var body: some View {
        VStack {
            Text("Bit-By-Bit")
                .font(Font.custom("3Dventure", size: 58, relativeTo: .title))
                .foregroundColor(bitByBitColors.randomElement()!)
                .easeIn(duration: 5)
                .padding(.top, 200)
            
            Text("Your personal 8-bit album displayer")
                .font(Font.custom("DINBold", size: 18))
                .foregroundColor(.white)
                .easeIn(duration: 10)
            
            Spacer()
            
            VStack {
                AuthorizeButton(serviceLogo: "spotifyLogo",
                                serviceToAuthorize: "Spotify",
                                buttonColor: .white,
                                buttonTextColor: .black)
                .padding()
                .opacity(buttonsHidden ? 0: 1)
                .easeIn(duration: 1)
                
                
                AuthorizeButton(
                    serviceLogo: "appleMusicLogo",
                    serviceToAuthorize: "Apple Music",
                    width: 64,
                    height: 64,
                    buttonColor: .pink
                )
                .opacity(buttonsHidden ? 0: 1)
                .easeIn(duration: 1)
            }
            .onAppear() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                    buttonsHidden.toggle()
                })
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
