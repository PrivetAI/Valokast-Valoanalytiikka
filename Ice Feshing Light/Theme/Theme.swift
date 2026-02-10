import SwiftUI

// MARK: - Color Palette
struct AppColors {
    // Primary colors
    static let primary = Color(red: 0.2, green: 0.5, blue: 0.7)
    static let primaryDark = Color(red: 0.15, green: 0.4, blue: 0.6)
    static let primaryLight = Color(red: 0.4, green: 0.65, blue: 0.85)
    
    // Background
    static let background = Color(red: 0.96, green: 0.97, blue: 0.98)
    static let cardBackground = Color.white
    static let surface = Color(red: 0.94, green: 0.95, blue: 0.97)
    
    // Text
    static let textPrimary = Color(red: 0.15, green: 0.2, blue: 0.25)
    static let textSecondary = Color(red: 0.45, green: 0.5, blue: 0.55)
    static let textLight = Color.white
    
    // Weather colors
    static let sunny = Color(red: 1.0, green: 0.75, blue: 0.2)
    static let cloudy = Color(red: 0.6, green: 0.7, blue: 0.8)
    static let overcast = Color(red: 0.5, green: 0.55, blue: 0.6)
    static let snowing = Color(red: 0.7, green: 0.8, blue: 0.9)
    
    // Rating colors
    static let excellent = Color(red: 0.3, green: 0.75, blue: 0.45)
    static let average = Color(red: 0.95, green: 0.75, blue: 0.3)
    static let poor = Color(red: 0.7, green: 0.7, blue: 0.7)
    
    // Time of day
    static let morning = Color(red: 1.0, green: 0.6, blue: 0.4)
    static let day = Color(red: 0.4, green: 0.7, blue: 0.9)
    static let evening = Color(red: 0.6, green: 0.4, blue: 0.7)
    static let night = Color(red: 0.2, green: 0.25, blue: 0.4)
    
    // Accent
    static let accent = Color(red: 0.3, green: 0.6, blue: 0.8)
    static let danger = Color(red: 0.9, green: 0.35, blue: 0.35)
}

// MARK: - Typography
struct AppTypography {
    static let largeTitle = Font.system(size: 28, weight: .bold)
    static let title = Font.system(size: 22, weight: .semibold)
    static let headline = Font.system(size: 18, weight: .semibold)
    static let body = Font.system(size: 16, weight: .regular)
    static let callout = Font.system(size: 14, weight: .medium)
    static let caption = Font.system(size: 12, weight: .regular)
    static let largeNumber = Font.system(size: 36, weight: .bold)
}

// MARK: - Spacing
struct AppSpacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
}

// MARK: - Corner Radius
struct AppCorners {
    static let small: CGFloat = 8
    static let medium: CGFloat = 12
    static let large: CGFloat = 16
    static let xl: CGFloat = 20
}

// MARK: - Shadows
struct AppShadows {
    static func card() -> some View {
        Color.black.opacity(0.08)
    }
}

// MARK: - Card Style Modifier
struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(AppColors.cardBackground)
            .cornerRadius(AppCorners.large)
            .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 2)
    }
}

extension View {
    func cardStyle() -> some View {
        modifier(CardStyle())
    }
}

// MARK: - Button Styles
struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppTypography.headline)
            .foregroundColor(AppColors.textLight)
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppSpacing.md)
            .background(
                RoundedRectangle(cornerRadius: AppCorners.medium)
                    .fill(configuration.isPressed ? AppColors.primaryDark : AppColors.primary)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppTypography.callout)
            .foregroundColor(AppColors.primary)
            .padding(.horizontal, AppSpacing.md)
            .padding(.vertical, AppSpacing.sm)
            .background(
                RoundedRectangle(cornerRadius: AppCorners.small)
                    .stroke(AppColors.primary, lineWidth: 1.5)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}
