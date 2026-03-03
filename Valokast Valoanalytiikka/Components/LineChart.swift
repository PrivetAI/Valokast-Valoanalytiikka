import SwiftUI

// MARK: - Hourly Light Profile Chart

struct HourlyLightChart: View {
    let dataPoints: [(hour: Int, lux: Double)]
    let maxLux: Double
    var highlightHours: [Int] = []

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let leftPad: CGFloat = 36
            let bottomPad: CGFloat = 20
            let topPad: CGFloat = 8
            let plotW = w - leftPad - 8
            let plotH = h - topPad - bottomPad
            let logMax = log10(max(10, maxLux))

            ZStack(alignment: .topLeading) {
                // Highlight zones
                ForEach(highlightHours, id: \.self) { hr in
                    if let idx = dataPoints.firstIndex(where: { $0.hour == hr }) {
                        let barW = plotW / 24
                        Rectangle()
                            .fill(AppTheme.amber.opacity(0.1))
                            .frame(width: barW, height: plotH)
                            .offset(x: leftPad + barW * CGFloat(idx), y: topPad)
                    }
                }

                // Curve fill
                Path { path in
                    for (i, dp) in dataPoints.enumerated() {
                        let x = leftPad + plotW * CGFloat(dp.hour) / 23.0
                        let logVal = log10(max(1, dp.lux))
                        let y = topPad + plotH * (1 - CGFloat(logVal / logMax))
                        if i == 0 { path.move(to: CGPoint(x: x, y: y)) }
                        else { path.addLine(to: CGPoint(x: x, y: y)) }
                    }
                    // Close for fill
                    if let last = dataPoints.last {
                        let lastX = leftPad + plotW * CGFloat(last.hour) / 23.0
                        path.addLine(to: CGPoint(x: lastX, y: topPad + plotH))
                    }
                    if let first = dataPoints.first {
                        let firstX = leftPad + plotW * CGFloat(first.hour) / 23.0
                        path.addLine(to: CGPoint(x: firstX, y: topPad + plotH))
                    }
                    path.closeSubpath()
                }
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [AppTheme.amber.opacity(0.25), AppTheme.amber.opacity(0.02)]),
                        startPoint: .top, endPoint: .bottom
                    )
                )

                // Line
                Path { path in
                    for (i, dp) in dataPoints.enumerated() {
                        let x = leftPad + plotW * CGFloat(dp.hour) / 23.0
                        let logVal = log10(max(1, dp.lux))
                        let y = topPad + plotH * (1 - CGFloat(logVal / logMax))
                        if i == 0 { path.move(to: CGPoint(x: x, y: y)) }
                        else { path.addLine(to: CGPoint(x: x, y: y)) }
                    }
                }
                .stroke(AppTheme.amber, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))

                // X-axis labels
                ForEach([0, 6, 12, 18, 23], id: \.self) { hr in
                    let x = leftPad + plotW * CGFloat(hr) / 23.0
                    Text("\(hr)h")
                        .font(.system(size: 9))
                        .foregroundColor(AppTheme.dimText)
                        .position(x: x, y: h - 6)
                }
            }
        }
    }
}
