import SwiftUI

// MARK: - Valokast Valoanalytiikka Theme
// Dark background with luminous yellow/amber accents

struct AppTheme {
    // Background colors
    static let backgroundPrimary = Color(red: 0.06, green: 0.07, blue: 0.10)
    static let backgroundSecondary = Color(red: 0.09, green: 0.10, blue: 0.14)
    static let backgroundCard = Color(red: 0.11, green: 0.12, blue: 0.17)

    // Accent / glow colors
    static let amber = Color(red: 1.0, green: 0.75, blue: 0.15)
    static let amberDim = Color(red: 1.0, green: 0.75, blue: 0.15).opacity(0.4)
    static let amberGlow = Color(red: 1.0, green: 0.85, blue: 0.3)
    static let warmWhite = Color(red: 1.0, green: 0.96, blue: 0.88)
    static let coolBlue = Color(red: 0.3, green: 0.55, blue: 0.85)
    static let deepBlue = Color(red: 0.12, green: 0.20, blue: 0.38)
    static let iceBlue = Color(red: 0.6, green: 0.78, blue: 0.92)
    static let dimText = Color(red: 0.55, green: 0.56, blue: 0.62)
    static let bodyText = Color(red: 0.82, green: 0.83, blue: 0.87)

    // Semantic
    static let highLight = Color(red: 1.0, green: 0.92, blue: 0.4)
    static let mediumLight = Color(red: 0.7, green: 0.65, blue: 0.3)
    static let lowLight = Color(red: 0.3, green: 0.3, blue: 0.5)
    static let veryLowLight = Color(red: 0.15, green: 0.15, blue: 0.28)

    static func luxColor(for lux: Double) -> Color {
        if lux > 5000 { return highLight }
        if lux > 1000 { return amber }
        if lux > 200 { return mediumLight }
        if lux > 20 { return lowLight }
        return veryLowLight
    }

    static func luxLabel(for lux: Double) -> String {
        if lux > 10000 { return "Bright" }
        if lux > 2000 { return "Moderate" }
        if lux > 200 { return "Dim" }
        if lux > 20 { return "Low" }
        return "Very Low"
    }
}
