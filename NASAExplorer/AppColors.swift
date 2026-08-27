import SwiftUI

enum AppColors {

    static let background = Color(
        red: 3 / 255,
        green: 7 / 255,
        blue: 18 / 255
    )

    static let surface = Color(
        red: 9 / 255,
        green: 20 / 255,
        blue: 42 / 255
    )

    static let surfaceElevated = Color(
        red: 15 / 255,
        green: 31 / 255,
        blue: 59 / 255
    )

    // MARK: - NASA Accents

    static let nasaBlue = Color(
        red: 11 / 255,
        green: 61 / 255,
        blue: 145 / 255
    )

    static let nasaRed = Color(
        red: 252 / 255,
        green: 61 / 255,
        blue: 33 / 255
    )

    static let orbitalBlue = Color(
        red: 51 / 255,
        green: 153 / 255,
        blue: 255 / 255
    )

    static let starGold = Color(
        red: 255 / 255,
        green: 196 / 255,
        blue: 87 / 255
    )

    // MARK: - Text

    static let primaryText = Color.white
    static let secondaryText = Color.white.opacity(0.70)
    static let tertiaryText = Color.white.opacity(0.45)

    // MARK: - Borders

    static let border = Color.white.opacity(0.12)
    static let highlightedBorder = orbitalBlue.opacity(0.55)

    // MARK: - Gradients

    static let spaceGradient = LinearGradient(
        colors: [
            background,
            surface,
            nasaBlue.opacity(0.65)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let nasaGradient = LinearGradient(
        colors: [
            nasaBlue,
            orbitalBlue,
            nasaRed
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
