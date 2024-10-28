

import SwiftUI

struct Background: View {
    var body: some View {
        ZStack {
            Color(hex: "##000000") // Custom color using hex code

        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct Background2: View {
    var body: some View {
        ZStack {
            Background() // Use your custom background
        }
    }
}

extension Color {
    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = Double((rgb >> 16) & 0xFF) / 255.0
        let green = Double((rgb >> 8) & 0xFF) / 255.0
        let blue = Double(rgb & 0xFF) / 255.0

        self.init(red: red, green: green, blue: blue)
    }
}

struct Background3: PreviewProvider {
    static var previews: some View {
        Background2()
    }
}
