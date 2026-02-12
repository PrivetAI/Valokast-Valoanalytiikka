import SwiftUI

// MARK: - Glow Slider Component

struct GlowSlider: View {
    let label: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    let step: Double
    let unit: String
    var format: String = "%.1f"

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(label)
                    .font(.subheadline)
                    .foregroundColor(AppTheme.dimText)
                Spacer()
                Text(String(format: format, value) + " " + unit)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(AppTheme.amber)
            }
            Slider(value: $value, in: range, step: step)
                .accentColor(AppTheme.amber)
        }
    }
}

// MARK: - Clarity Picker

struct ClarityPicker: View {
    @Binding var clarity: IceCondition.WaterClarity

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Water Clarity")
                .font(.subheadline)
                .foregroundColor(AppTheme.dimText)
            HStack(spacing: 6) {
                ForEach(IceCondition.WaterClarity.allCases, id: \.self) { option in
                    Button(action: { clarity = option }) {
                        Text(shortLabel(option))
                            .font(.caption2)
                            .fontWeight(.medium)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 6)
                            .foregroundColor(clarity == option ? AppTheme.backgroundPrimary : AppTheme.bodyText)
                            .background(clarity == option ? AppTheme.amber : AppTheme.backgroundSecondary)
                            .cornerRadius(8)
                    }
                }
            }
        }
    }

    private func shortLabel(_ c: IceCondition.WaterClarity) -> String {
        switch c {
        case .crystal: return "Crystal"
        case .clear: return "Clear"
        case .moderate: return "Mod"
        case .stained: return "Stain"
        case .murky: return "Murky"
        }
    }
}
