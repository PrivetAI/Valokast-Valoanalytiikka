import SwiftUI

// MARK: - Depth Light Graph (light attenuation curve)

struct DepthLightGraph: View {
    let condition: IceCondition
    let surfaceLux: Double
    let maxDepthFeet: Double
    var highlightDepth: Double? = nil
    var speciesRange: (min: Double, max: Double)? = nil

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let leftPad: CGFloat = 44
            let rightPad: CGFloat = 16
            let topPad: CGFloat = 10
            let bottomPad: CGFloat = 24
            let plotW = w - leftPad - rightPad
            let plotH = h - topPad - bottomPad

            ZStack(alignment: .topLeading) {
                // Background gradient (dark water)
                LinearGradient(
                    gradient: Gradient(colors: [AppTheme.deepBlue.opacity(0.3), AppTheme.backgroundPrimary]),
                    startPoint: .top, endPoint: .bottom
                )
                .cornerRadius(8)

                // Species preferred zone
                if let sr = speciesRange {
                    let yMin = topPad + plotH * CGFloat(depthForLux(sr.max) / maxDepthFeet)
                    let yMax = topPad + plotH * CGFloat(depthForLux(sr.min) / maxDepthFeet)
                    Rectangle()
                        .fill(AppTheme.amber.opacity(0.08))
                        .frame(width: plotW, height: max(0, yMax - yMin))
                        .offset(x: leftPad, y: yMin)
                }

                // Light curve
                Path { path in
                    let steps = 50
                    for i in 0...steps {
                        let depth = maxDepthFeet * Double(i) / Double(steps)
                        let lux = condition.luxAtDepth(surfaceLux: surfaceLux, depthFeet: depth)
                        let maxLux = surfaceLux * condition.iceTransmittance
                        let xFraction = maxLux > 0 ? min(1, log10(max(1, lux)) / log10(max(10, maxLux))) : 0
                        let x = leftPad + plotW * CGFloat(xFraction)
                        let y = topPad + plotH * CGFloat(depth / maxDepthFeet)
                        if i == 0 { path.move(to: CGPoint(x: x, y: y)) }
                        else { path.addLine(to: CGPoint(x: x, y: y)) }
                    }
                }
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [AppTheme.amberGlow, AppTheme.lowLight]),
                        startPoint: .top, endPoint: .bottom
                    ),
                    style: StrokeStyle(lineWidth: 2.5, lineCap: .round)
                )

                // Highlight depth line
                if let hd = highlightDepth, hd <= maxDepthFeet {
                    let y = topPad + plotH * CGFloat(hd / maxDepthFeet)
                    Path { path in
                        path.move(to: CGPoint(x: leftPad, y: y))
                        path.addLine(to: CGPoint(x: leftPad + plotW, y: y))
                    }
                    .stroke(AppTheme.amber, style: StrokeStyle(lineWidth: 1, dash: [4, 4]))

                    let luxAtH = condition.luxAtDepth(surfaceLux: surfaceLux, depthFeet: hd)
                    Text(String(format: "%.0f lux", luxAtH))
                        .font(.caption2)
                        .foregroundColor(AppTheme.amber)
                        .offset(x: leftPad + plotW - 50, y: y - 16)
                }

                // Y-axis labels (depth)
                ForEach(0..<6) { i in
                    let depth = maxDepthFeet * Double(i) / 5.0
                    let y = topPad + plotH * CGFloat(Double(i) / 5.0)
                    Text(String(format: "%.0f ft", depth))
                        .font(.system(size: 9))
                        .foregroundColor(AppTheme.dimText)
                        .position(x: leftPad / 2, y: y)
                }

                // X-axis label
                Text("Light Intensity (log)")
                    .font(.system(size: 9))
                    .foregroundColor(AppTheme.dimText)
                    .position(x: leftPad + plotW / 2, y: h - 6)
            }
        }
    }

    private func depthForLux(_ targetLux: Double) -> Double {
        let luxBelowIce = surfaceLux * condition.iceTransmittance
        guard luxBelowIce > 0, targetLux > 0 else { return maxDepthFeet }
        let kd = condition.waterClarity.attenuationCoefficient
        guard kd > 0 else { return 0 }
        let depthM = -log(targetLux / luxBelowIce) / kd
        return max(0, min(maxDepthFeet, depthM / 0.3048))
    }
}
