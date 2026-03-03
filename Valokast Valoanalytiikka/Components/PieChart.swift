import SwiftUI

// MARK: - Lux Gauge (circular gauge)

struct LuxGauge: View {
    let currentLux: Double
    let maxLux: Double
    let label: String

    private var fraction: Double {
        guard maxLux > 0, currentLux > 0 else { return 0 }
        return min(1, log10(max(1, currentLux)) / log10(max(10, maxLux)))
    }

    var body: some View {
        VStack(spacing: 6) {
            ZStack {
                // Background arc
                Circle()
                    .trim(from: 0, to: 0.75)
                    .stroke(AppTheme.backgroundSecondary, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                    .rotationEffect(.degrees(135))

                // Value arc
                Circle()
                    .trim(from: 0, to: CGFloat(fraction) * 0.75)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [AppTheme.lowLight, AppTheme.amber, AppTheme.highLight]),
                            startPoint: .leading, endPoint: .trailing
                        ),
                        style: StrokeStyle(lineWidth: 6, lineCap: .round)
                    )
                    .rotationEffect(.degrees(135))

                VStack(spacing: 2) {
                    Text(luxText)
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(AppTheme.luxColor(for: currentLux))
                    Text("lux")
                        .font(.system(size: 9))
                        .foregroundColor(AppTheme.dimText)
                }
            }

            Text(label)
                .font(.caption2)
                .foregroundColor(AppTheme.dimText)
        }
    }

    private var luxText: String {
        if currentLux >= 10000 { return String(format: "%.0fk", currentLux / 1000) }
        if currentLux >= 100 { return String(format: "%.0f", currentLux) }
        return String(format: "%.1f", currentLux)
    }
}
