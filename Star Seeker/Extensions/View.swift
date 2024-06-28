import SwiftUI

extension View {
    func customFont ( size: CGFloat ) -> some View {
        self.modifier(CustomFontModifier(size: size))
    }
}

struct CustomFontModifier: ViewModifier {
    let size : CGFloat

    func body ( content: Content ) -> some View {
        content.font(.custom("Chainwhacks", size: size))
    }
}
