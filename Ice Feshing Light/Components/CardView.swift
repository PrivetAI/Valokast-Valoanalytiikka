import SwiftUI

// MARK: - Glow Card View

struct GlowCardView<Content: View>: View {
    let glowColor: Color
    let content: () -> Content

    init(glowColor: Color = AppTheme.amber, @ViewBuilder content: @escaping () -> Content) {
        self.glowColor = glowColor
        self.content = content
    }

    var body: some View {
        content()
            .padding(16)
            .background(AppTheme.backgroundCard)
            .cornerRadius(14)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(glowColor.opacity(0.3), lineWidth: 1)
            )
            .shadow(color: glowColor.opacity(0.15), radius: 8, x: 0, y: 2)
    }
}

// Section header used across the app
struct SectionHeader: View {
    let title: String
    let icon: AnyView

    var body: some View {
        HStack(spacing: 10) {
            icon
                .frame(width: 22, height: 22)
            Text(title)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(AppTheme.warmWhite)
            Spacer()
        }
    }
}
