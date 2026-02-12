import SwiftUI

// MARK: - Time Window Bar Chart

struct TimeWindowBarChart: View {
    let windows: [(label: String, score: Double)] // score 0-100
    let accentColor: Color

    init(windows: [(label: String, score: Double)], accentColor: Color = AppTheme.amber) {
        self.windows = windows
        self.accentColor = accentColor
    }

    var body: some View {
        VStack(spacing: 6) {
            ForEach(Array(windows.enumerated()), id: \.offset) { idx, window in
                HStack(spacing: 8) {
                    Text(window.label)
                        .font(.caption)
                        .foregroundColor(AppTheme.dimText)
                        .frame(width: 60, alignment: .trailing)

                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(AppTheme.backgroundSecondary)
                                .frame(height: 14)
                            Capsule()
                                .fill(barColor(score: window.score))
                                .frame(width: geo.size.width * CGFloat(window.score / 100), height: 14)
                        }
                    }
                    .frame(height: 14)

                    Text(String(format: "%.0f%%", window.score))
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(barColor(score: window.score))
                        .frame(width: 36, alignment: .leading)
                }
            }
        }
    }

    private func barColor(score: Double) -> Color {
        if score >= 70 { return AppTheme.amberGlow }
        if score >= 40 { return AppTheme.amber }
        return AppTheme.lowLight
    }
}
