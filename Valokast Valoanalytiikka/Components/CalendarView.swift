import SwiftUI

// MARK: - Decorative Light Ray Shapes

struct LightRaysView: View {
    let rayCount: Int
    let color: Color

    init(rayCount: Int = 12, color: Color = AppTheme.amber) {
        self.rayCount = rayCount
        self.color = color
    }

    var body: some View {
        GeometryReader { geo in
            let c = CGPoint(x: geo.size.width / 2, y: 0)
            ForEach(0..<rayCount, id: \.self) { i in
                let startAngle = Double(i) * (180.0 / Double(rayCount))
                let endAngle = startAngle + (90.0 / Double(rayCount))
                LightRayPath(center: c, startAngle: startAngle, endAngle: endAngle,
                             length: max(geo.size.width, geo.size.height) * 1.2)
                    .fill(color.opacity(0.03 + Double(i % 3) * 0.02))
            }
        }
        .allowsHitTesting(false)
    }
}

struct LightRayPath: Shape {
    let center: CGPoint
    let startAngle: Double
    let endAngle: Double
    let length: CGFloat

    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: center)
        let sa = Angle.degrees(startAngle)
        let ea = Angle.degrees(endAngle)
        p.addLine(to: CGPoint(
            x: center.x + length * CGFloat(cos(sa.radians)),
            y: center.y + length * CGFloat(sin(sa.radians))
        ))
        p.addLine(to: CGPoint(
            x: center.x + length * CGFloat(cos(ea.radians)),
            y: center.y + length * CGFloat(sin(ea.radians))
        ))
        p.closeSubpath()
        return p
    }
}

// Ice layer cross-section diagram
struct IceCrossSectionView: View {
    let iceThickness: Double
    let snowCover: Double

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let snowH = CGFloat(min(snowCover / 12.0, 0.3)) * h
            let iceH = CGFloat(min(iceThickness / 36.0, 0.4)) * h

            ZStack(alignment: .top) {
                // Sky / light source
                Rectangle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [AppTheme.amberGlow.opacity(0.15), Color.clear]),
                            startPoint: .top, endPoint: .center
                        )
                    )

                VStack(spacing: 0) {
                    // Air gap
                    Spacer().frame(height: h * 0.15)

                    // Snow layer
                    if snowH > 0 {
                        Rectangle()
                            .fill(Color.white.opacity(0.25))
                            .frame(height: snowH)
                            .overlay(
                                Text("Snow")
                                    .font(.system(size: 9))
                                    .foregroundColor(AppTheme.dimText)
                            )
                    }

                    // Ice layer
                    Rectangle()
                        .fill(AppTheme.iceBlue.opacity(0.25))
                        .frame(height: iceH)
                        .overlay(
                            Text("Ice")
                                .font(.system(size: 9))
                                .foregroundColor(AppTheme.iceBlue)
                        )

                    // Water
                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [AppTheme.deepBlue.opacity(0.4), AppTheme.backgroundPrimary]),
                                startPoint: .top, endPoint: .bottom
                            )
                        )

                }

                // Light beam through layers
                LightBeamShape()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [AppTheme.amberGlow.opacity(0.2), AppTheme.amber.opacity(0.02)]),
                            startPoint: .top, endPoint: .bottom
                        )
                    )
                    .frame(width: w * 0.4, height: h)
            }
        }
    }
}
