import SwiftUI

struct PauseScreen : View {
    var body : some View {
        HStack {
            Spacer()
            VStack {
                Text("Game Paused")
                    .font(.largeTitle)
                    .bold()
                    .foregroundStyle(.background)
                    .padding(.top, UIConfig.Paddings.huge * 6)
                Spacer()
            }
                .padding()
            Spacer()
        }
        .background(.black.opacity(0.5))
    }
}
