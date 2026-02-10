import SwiftUI

// MARK: - Calendar Icon
struct CalendarIcon: View {
    var size: CGFloat = 24
    var color: Color = AppColors.textPrimary
    
    var body: some View {
        ZStack {
            // Calendar body
            RoundedRectangle(cornerRadius: size * 0.15)
                .stroke(color, lineWidth: 1.5)
                .frame(width: size * 0.85, height: size * 0.85)
                .offset(y: size * 0.05)
            
            // Top bar
            Rectangle()
                .fill(color)
                .frame(width: size * 0.85, height: size * 0.18)
                .offset(y: -size * 0.28)
            
            // Rings
            HStack(spacing: size * 0.25) {
                RoundedRectangle(cornerRadius: 1)
                    .fill(color)
                    .frame(width: size * 0.08, height: size * 0.2)
                RoundedRectangle(cornerRadius: 1)
                    .fill(color)
                    .frame(width: size * 0.08, height: size * 0.2)
            }
            .offset(y: -size * 0.38)
            
            // Grid dots
            VStack(spacing: size * 0.1) {
                HStack(spacing: size * 0.15) {
                    Circle().fill(color).frame(width: size * 0.08, height: size * 0.08)
                    Circle().fill(color).frame(width: size * 0.08, height: size * 0.08)
                    Circle().fill(color).frame(width: size * 0.08, height: size * 0.08)
                }
                HStack(spacing: size * 0.15) {
                    Circle().fill(color).frame(width: size * 0.08, height: size * 0.08)
                    Circle().fill(color).frame(width: size * 0.08, height: size * 0.08)
                    Circle().fill(color).frame(width: size * 0.08, height: size * 0.08)
                }
            }
            .offset(y: size * 0.15)
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Chart Icon
struct ChartIcon: View {
    var size: CGFloat = 24
    var color: Color = AppColors.textPrimary
    
    var body: some View {
        ZStack {
            // Bars
            HStack(alignment: .bottom, spacing: size * 0.1) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(color)
                    .frame(width: size * 0.18, height: size * 0.4)
                RoundedRectangle(cornerRadius: 2)
                    .fill(color)
                    .frame(width: size * 0.18, height: size * 0.7)
                RoundedRectangle(cornerRadius: 2)
                    .fill(color)
                    .frame(width: size * 0.18, height: size * 0.5)
                RoundedRectangle(cornerRadius: 2)
                    .fill(color)
                    .frame(width: size * 0.18, height: size * 0.85)
            }
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Settings Icon (Gear)
struct SettingsIcon: View {
    var size: CGFloat = 24
    var color: Color = AppColors.textPrimary
    
    var body: some View {
        ZStack {
            // Outer teeth
            ForEach(0..<8) { i in
                RoundedRectangle(cornerRadius: 2)
                    .fill(color)
                    .frame(width: size * 0.15, height: size * 0.25)
                    .offset(y: -size * 0.38)
                    .rotationEffect(.degrees(Double(i) * 45))
            }
            
            // Outer ring
            Circle()
                .fill(color)
                .frame(width: size * 0.6, height: size * 0.6)
            
            // Inner hole
            Circle()
                .fill(Color.white)
                .frame(width: size * 0.25, height: size * 0.25)
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Save Icon (Checkmark in circle)
struct SaveIcon: View {
    var size: CGFloat = 24
    var color: Color = AppColors.textLight
    
    var body: some View {
        ZStack {
            // Checkmark
            Path { path in
                let w = size
                path.move(to: CGPoint(x: w * 0.25, y: w * 0.5))
                path.addLine(to: CGPoint(x: w * 0.42, y: w * 0.68))
                path.addLine(to: CGPoint(x: w * 0.75, y: w * 0.32))
            }
            .stroke(color, style: StrokeStyle(lineWidth: size * 0.1, lineCap: .round, lineJoin: .round))
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Back Icon (Arrow)
struct BackIcon: View {
    var size: CGFloat = 24
    var color: Color = AppColors.textPrimary
    
    var body: some View {
        Path { path in
            let w = size
            path.move(to: CGPoint(x: w * 0.6, y: w * 0.2))
            path.addLine(to: CGPoint(x: w * 0.3, y: w * 0.5))
            path.addLine(to: CGPoint(x: w * 0.6, y: w * 0.8))
        }
        .stroke(color, style: StrokeStyle(lineWidth: size * 0.1, lineCap: .round, lineJoin: .round))
        .frame(width: size, height: size)
    }
}

// MARK: - Plus Icon
struct PlusIcon: View {
    var size: CGFloat = 24
    var color: Color = AppColors.textPrimary
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 2)
                .fill(color)
                .frame(width: size * 0.6, height: size * 0.12)
            RoundedRectangle(cornerRadius: 2)
                .fill(color)
                .frame(width: size * 0.12, height: size * 0.6)
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Delete Icon (Trash)
struct DeleteIcon: View {
    var size: CGFloat = 24
    var color: Color = AppColors.danger
    
    var body: some View {
        ZStack {
            // Lid
            RoundedRectangle(cornerRadius: 1)
                .fill(color)
                .frame(width: size * 0.7, height: size * 0.08)
                .offset(y: -size * 0.32)
            
            // Handle
            RoundedRectangle(cornerRadius: 2)
                .stroke(color, lineWidth: 1.5)
                .frame(width: size * 0.25, height: size * 0.12)
                .offset(y: -size * 0.4)
            
            // Body
            Path { path in
                let w = size
                path.move(to: CGPoint(x: w * 0.2, y: w * 0.25))
                path.addLine(to: CGPoint(x: w * 0.25, y: w * 0.85))
                path.addLine(to: CGPoint(x: w * 0.75, y: w * 0.85))
                path.addLine(to: CGPoint(x: w * 0.8, y: w * 0.25))
                path.closeSubpath()
            }
            .stroke(color, lineWidth: 1.5)
            
            // Lines
            VStack(spacing: size * 0.12) {
                RoundedRectangle(cornerRadius: 0.5)
                    .fill(color)
                    .frame(width: size * 0.06, height: size * 0.35)
            }
            .offset(y: size * 0.12)
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Compare Icon
struct CompareIcon: View {
    var size: CGFloat = 24
    var color: Color = AppColors.textPrimary
    
    var body: some View {
        ZStack {
            // Left arrow
            Path { path in
                let w = size
                path.move(to: CGPoint(x: w * 0.35, y: w * 0.25))
                path.addLine(to: CGPoint(x: w * 0.15, y: w * 0.4))
                path.addLine(to: CGPoint(x: w * 0.35, y: w * 0.55))
            }
            .stroke(color, style: StrokeStyle(lineWidth: size * 0.08, lineCap: .round, lineJoin: .round))
            
            // Right arrow
            Path { path in
                let w = size
                path.move(to: CGPoint(x: w * 0.65, y: w * 0.45))
                path.addLine(to: CGPoint(x: w * 0.85, y: w * 0.6))
                path.addLine(to: CGPoint(x: w * 0.65, y: w * 0.75))
            }
            .stroke(color, style: StrokeStyle(lineWidth: size * 0.08, lineCap: .round, lineJoin: .round))
            
            // Lines
            RoundedRectangle(cornerRadius: 1)
                .fill(color)
                .frame(width: size * 0.5, height: size * 0.06)
                .offset(y: -size * 0.1)
            
            RoundedRectangle(cornerRadius: 1)
                .fill(color)
                .frame(width: size * 0.5, height: size * 0.06)
                .offset(y: size * 0.1)
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Fish Icon
struct FishIcon: View {
    var size: CGFloat = 24
    var color: Color = AppColors.primary
    
    var body: some View {
        ZStack {
            // Body
            Ellipse()
                .fill(color)
                .frame(width: size * 0.7, height: size * 0.4)
            
            // Tail
            Path { path in
                let w = size
                path.move(to: CGPoint(x: w * 0.15, y: w * 0.5))
                path.addLine(to: CGPoint(x: w * 0.0, y: w * 0.3))
                path.addLine(to: CGPoint(x: w * 0.0, y: w * 0.7))
                path.closeSubpath()
            }
            .fill(color)
            
            // Eye
            Circle()
                .fill(Color.white)
                .frame(width: size * 0.12, height: size * 0.12)
                .offset(x: size * 0.2, y: -size * 0.02)
            
            Circle()
                .fill(AppColors.textPrimary)
                .frame(width: size * 0.06, height: size * 0.06)
                .offset(x: size * 0.21, y: -size * 0.02)
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Stats Icon
struct StatsIcon: View {
    var size: CGFloat = 24
    var color: Color = AppColors.textPrimary
    
    var body: some View {
        ZStack {
            // Line chart
            Path { path in
                let w = size
                path.move(to: CGPoint(x: w * 0.1, y: w * 0.7))
                path.addLine(to: CGPoint(x: w * 0.35, y: w * 0.4))
                path.addLine(to: CGPoint(x: w * 0.55, y: w * 0.55))
                path.addLine(to: CGPoint(x: w * 0.9, y: w * 0.2))
            }
            .stroke(color, style: StrokeStyle(lineWidth: size * 0.08, lineCap: .round, lineJoin: .round))
            
            // Dots
            Circle()
                .fill(color)
                .frame(width: size * 0.12, height: size * 0.12)
                .offset(x: -size * 0.15, y: size * 0.1)
            
            Circle()
                .fill(color)
                .frame(width: size * 0.12, height: size * 0.12)
                .offset(x: size * 0.05, y: size * 0.05)
            
            Circle()
                .fill(color)
                .frame(width: size * 0.12, height: size * 0.12)
                .offset(x: size * 0.4, y: -size * 0.3)
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Home Icon
struct HomeIcon: View {
    var size: CGFloat = 24
    var color: Color = AppColors.textPrimary
    
    var body: some View {
        ZStack {
            // Roof
            Path { path in
                let w = size
                path.move(to: CGPoint(x: w * 0.5, y: w * 0.1))
                path.addLine(to: CGPoint(x: w * 0.1, y: w * 0.45))
                path.addLine(to: CGPoint(x: w * 0.9, y: w * 0.45))
                path.closeSubpath()
            }
            .fill(color)
            
            // Body
            Rectangle()
                .fill(color)
                .frame(width: size * 0.55, height: size * 0.42)
                .offset(y: size * 0.22)
            
            // Door
            Rectangle()
                .fill(Color.white)
                .frame(width: size * 0.18, height: size * 0.25)
                .offset(y: size * 0.3)
        }
        .frame(width: size, height: size)
    }
}
