import SwiftUI

// MARK: - Custom UI Shape Icons (no SF Symbols)

struct FishShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width
        let h = rect.height
        // Body
        p.move(to: CGPoint(x: w * 0.15, y: h * 0.5))
        p.addCurve(to: CGPoint(x: w * 0.75, y: h * 0.5),
                    control1: CGPoint(x: w * 0.35, y: h * 0.1),
                    control2: CGPoint(x: w * 0.6, y: h * 0.15))
        // Tail top
        p.addLine(to: CGPoint(x: w * 0.95, y: h * 0.2))
        p.addLine(to: CGPoint(x: w * 0.85, y: h * 0.5))
        p.addLine(to: CGPoint(x: w * 0.95, y: h * 0.8))
        p.addLine(to: CGPoint(x: w * 0.75, y: h * 0.5))
        // Bottom curve
        p.addCurve(to: CGPoint(x: w * 0.15, y: h * 0.5),
                    control1: CGPoint(x: w * 0.6, y: h * 0.85),
                    control2: CGPoint(x: w * 0.35, y: h * 0.9))
        p.closeSubpath()
        // Eye
        p.addEllipse(in: CGRect(x: w * 0.28, y: h * 0.38, width: w * 0.08, height: h * 0.1))
        return p
    }
}

struct ChartLineShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let points: [(CGFloat, CGFloat)] = [
            (0.05, 0.8), (0.25, 0.4), (0.45, 0.6), (0.65, 0.2), (0.85, 0.5), (0.95, 0.3)
        ]
        for (i, pt) in points.enumerated() {
            let point = CGPoint(x: rect.width * pt.0, y: rect.height * pt.1)
            if i == 0 { p.move(to: point) } else { p.addLine(to: point) }
        }
        return p
    }
}

struct BookShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width
        let h = rect.height
        // Left page
        p.move(to: CGPoint(x: w * 0.5, y: h * 0.15))
        p.addLine(to: CGPoint(x: w * 0.1, y: h * 0.1))
        p.addLine(to: CGPoint(x: w * 0.1, y: h * 0.85))
        p.addLine(to: CGPoint(x: w * 0.5, y: h * 0.9))
        // Right page
        p.addLine(to: CGPoint(x: w * 0.9, y: h * 0.85))
        p.addLine(to: CGPoint(x: w * 0.9, y: h * 0.1))
        p.addLine(to: CGPoint(x: w * 0.5, y: h * 0.15))
        // Spine
        p.move(to: CGPoint(x: w * 0.5, y: h * 0.15))
        p.addLine(to: CGPoint(x: w * 0.5, y: h * 0.9))
        return p
    }
}

struct ClockShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let c = CGPoint(x: rect.midX, y: rect.midY)
        let r = min(rect.width, rect.height) * 0.42
        p.addEllipse(in: CGRect(x: c.x - r, y: c.y - r, width: r * 2, height: r * 2))
        // Hour hand
        p.move(to: c)
        p.addLine(to: CGPoint(x: c.x + r * 0.3, y: c.y - r * 0.4))
        // Minute hand
        p.move(to: c)
        p.addLine(to: CGPoint(x: c.x, y: c.y - r * 0.65))
        return p
    }
}

struct JournalShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width
        let h = rect.height
        // Notebook outline
        p.addRoundedRect(in: CGRect(x: w * 0.15, y: h * 0.08, width: w * 0.7, height: h * 0.84), cornerSize: CGSize(width: 4, height: 4))
        // Lines
        for i in 1...4 {
            let y = h * (0.2 + CGFloat(i) * 0.13)
            p.move(to: CGPoint(x: w * 0.25, y: y))
            p.addLine(to: CGPoint(x: w * 0.75, y: y))
        }
        // Binding
        p.move(to: CGPoint(x: w * 0.15, y: h * 0.08))
        p.addLine(to: CGPoint(x: w * 0.15, y: h * 0.92))
        return p
    }
}

struct GearShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let c = CGPoint(x: rect.midX, y: rect.midY)
        let outerR = min(rect.width, rect.height) * 0.42
        let innerR = outerR * 0.7
        let teeth = 8
        for i in 0..<(teeth * 2) {
            let angle = CGFloat(i) * .pi / CGFloat(teeth)
            let r = i % 2 == 0 ? outerR : innerR
            let pt = CGPoint(x: c.x + cos(angle) * r, y: c.y + sin(angle) * r)
            if i == 0 { p.move(to: pt) } else { p.addLine(to: pt) }
        }
        p.closeSubpath()
        // Center hole
        let holeR = outerR * 0.25
        p.addEllipse(in: CGRect(x: c.x - holeR, y: c.y - holeR, width: holeR * 2, height: holeR * 2))
        return p
    }
}

struct DepthArrowShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width
        let h = rect.height
        // Downward arrow
        p.move(to: CGPoint(x: w * 0.5, y: h * 0.1))
        p.addLine(to: CGPoint(x: w * 0.5, y: h * 0.7))
        p.addLine(to: CGPoint(x: w * 0.25, y: h * 0.55))
        p.move(to: CGPoint(x: w * 0.5, y: h * 0.7))
        p.addLine(to: CGPoint(x: w * 0.75, y: h * 0.55))
        // Waves at bottom
        p.move(to: CGPoint(x: w * 0.15, y: h * 0.85))
        p.addQuadCurve(to: CGPoint(x: w * 0.5, y: h * 0.85),
                        control: CGPoint(x: w * 0.33, y: h * 0.75))
        p.addQuadCurve(to: CGPoint(x: w * 0.85, y: h * 0.85),
                        control: CGPoint(x: w * 0.67, y: h * 0.95))
        return p
    }
}
