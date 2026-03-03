import SwiftUI

// MARK: - Custom Light-Related Shape Icons (no SF Symbols, no emoji)

struct SunShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let c = CGPoint(x: rect.midX, y: rect.midY)
        let r = min(rect.width, rect.height) * 0.25
        p.addEllipse(in: CGRect(x: c.x - r, y: c.y - r, width: r * 2, height: r * 2))
        // Rays
        let rayLen = min(rect.width, rect.height) * 0.18
        let rayStart = r * 1.3
        for i in 0..<8 {
            let angle = CGFloat(i) * .pi / 4
            let sx = c.x + cos(angle) * rayStart
            let sy = c.y + sin(angle) * rayStart
            let ex = c.x + cos(angle) * (rayStart + rayLen)
            let ey = c.y + sin(angle) * (rayStart + rayLen)
            p.move(to: CGPoint(x: sx, y: sy))
            p.addLine(to: CGPoint(x: ex, y: ey))
        }
        return p
    }
}

struct MoonShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let c = CGPoint(x: rect.midX, y: rect.midY)
        let r = min(rect.width, rect.height) * 0.38
        p.addArc(center: c, radius: r, startAngle: .degrees(-90), endAngle: .degrees(90), clockwise: false)
        let offset = r * 0.6
        p.addArc(center: CGPoint(x: c.x + offset, y: c.y), radius: r * 0.85, startAngle: .degrees(90), endAngle: .degrees(-90), clockwise: true)
        p.closeSubpath()
        return p
    }
}

struct LightBeamShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let topCenter = CGPoint(x: rect.midX, y: rect.minY)
        let spread = rect.width * 0.4
        p.move(to: topCenter)
        p.addLine(to: CGPoint(x: rect.midX - spread, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.midX + spread, y: rect.maxY))
        p.closeSubpath()
        return p
    }
}

struct SnowflakeShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let c = CGPoint(x: rect.midX, y: rect.midY)
        let r = min(rect.width, rect.height) * 0.4
        for i in 0..<6 {
            let angle = CGFloat(i) * .pi / 3
            p.move(to: c)
            let end = CGPoint(x: c.x + cos(angle) * r, y: c.y + sin(angle) * r)
            p.addLine(to: end)
            // Small branches
            let mid = CGPoint(x: c.x + cos(angle) * r * 0.6, y: c.y + sin(angle) * r * 0.6)
            let branchLen = r * 0.3
            let a1 = angle + .pi / 6
            let a2 = angle - .pi / 6
            p.move(to: mid)
            p.addLine(to: CGPoint(x: mid.x + cos(a1) * branchLen, y: mid.y + sin(a1) * branchLen))
            p.move(to: mid)
            p.addLine(to: CGPoint(x: mid.x + cos(a2) * branchLen, y: mid.y + sin(a2) * branchLen))
        }
        return p
    }
}

struct WaterWaveShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let midY = rect.midY
        let amp = rect.height * 0.2
        p.move(to: CGPoint(x: rect.minX, y: midY))
        let segments = 4
        let segW = rect.width / CGFloat(segments)
        for i in 0..<segments {
            let x1 = rect.minX + CGFloat(i) * segW + segW * 0.5
            let x2 = rect.minX + CGFloat(i + 1) * segW
            let cp1y = midY + (i % 2 == 0 ? -amp : amp)
            let cp2y = midY + (i % 2 == 0 ? -amp : amp)
            p.addCurve(to: CGPoint(x: x2, y: midY),
                       control1: CGPoint(x: x1, y: cp1y),
                       control2: CGPoint(x: x1, y: cp2y))
        }
        return p
    }
}

struct IceCrystalShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let c = CGPoint(x: rect.midX, y: rect.midY)
        let r = min(rect.width, rect.height) * 0.42
        // Hexagon
        for i in 0..<6 {
            let angle = CGFloat(i) * .pi / 3 - .pi / 6
            let pt = CGPoint(x: c.x + cos(angle) * r, y: c.y + sin(angle) * r)
            if i == 0 { p.move(to: pt) } else { p.addLine(to: pt) }
        }
        p.closeSubpath()
        return p
    }
}
