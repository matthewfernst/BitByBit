//
//  AuthorizeButton.swift
//  SpotifyBitDisplay
//
//  Created by Matthew Ernst on 6/15/22.
//

import SwiftUI

struct AuthorizeButton: View
{
    
    var serviceLogo: String
    var serviceToAuthorize: String
    var contactServiceAction: (() -> ())?
    var width = 32.0
    var height = 32.0
    var buttonColor: Color = .black
    var buttonTextColor: Color = .white
    
    var body: some View {
        Button(action: {
            contactServiceAction?()
            debugPrint("contacting \(serviceToAuthorize)")
        }) {
            Image(serviceLogo)
                .resizable()
                .scaledToFit()
                .frame(width: width, height: height)
            
            Text("Authorize \(serviceToAuthorize)")
                .bold()
                .foregroundColor(buttonTextColor)
                .padding(.leading, 4)
        }
        .background(RoundedRectangle(cornerRadius: 25)
            .fill(buttonColor)
            .frame(width: 280, height: 60)
        )
        
    }
}
