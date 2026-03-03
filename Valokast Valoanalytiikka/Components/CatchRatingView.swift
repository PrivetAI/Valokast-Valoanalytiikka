import SwiftUI

// MARK: - Light Level Indicator (visual lux display)

struct LightLevelIndicator: View {
    let lux: Double
    let maxLux: Double

    private var fraction: CGFloat {
        guard maxLux > 0 else { return 0 }
        return CGFloat(min(1, max(0, log10(max(1, lux)) / log10(max(10, maxLux)))))
    }

    var body: some View {
        VStack(spacing: 8) {
            // Lux value
            Text(luxFormatted)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(AppTheme.luxColor(for: lux))

            Text("lux")
                .font(.caption)
                .foregroundColor(AppTheme.dimText)

            // Bar indicator
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(AppTheme.backgroundSecondary)
                        .frame(height: 8)
                    Capsule()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [AppTheme.veryLowLight, AppTheme.lowLight, AppTheme.amber, AppTheme.highLight]),
                                startPoint: .leading, endPoint: .trailing
                            )
                        )
                        .frame(width: geo.size.width * fraction, height: 8)
                }
            }
            .frame(height: 8)

            Text(AppTheme.luxLabel(for: lux))
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(AppTheme.luxColor(for: lux))
        }
    }

    private var luxFormatted: String {
        if lux >= 10000 { return String(format: "%.0fk", lux / 1000) }
        if lux >= 100 { return String(format: "%.0f", lux) }
        if lux >= 1 { return String(format: "%.1f", lux) }
        return String(format: "%.2f", lux)
    }
}
