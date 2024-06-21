//
//  View.swift
//  Star Seeker
//
//  Created by Elian Richard on 21/06/24.
//

import SwiftUI

struct CustomFontModifier: ViewModifier {
    let size: CGFloat
    
    func body(content: Content) -> some View {
        content.font(.custom("Chainwhacks", size: size))
    }
}

extension View {
    func customFont(size: CGFloat) -> some View {
        self.modifier(CustomFontModifier(size: size))
    }
}
