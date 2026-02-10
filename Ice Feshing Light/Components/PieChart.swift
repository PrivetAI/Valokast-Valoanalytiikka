import SwiftUI

struct PieSlice: Identifiable {
    let id = UUID()
    let label: String
    let value: Double
    let color: Color
}

struct PieChart: View {
    let slices: [PieSlice]
    var showLegend: Bool = true
    
    private var total: Double {
        slices.map { $0.value }.reduce(0, +)
    }
    
    var body: some View {
        HStack(spacing: AppSpacing.lg) {
            // Pie
            GeometryReader { geometry in
                let size = min(geometry.size.width, geometry.size.height)
                
                ZStack {
                    ForEach(Array(zip(slices.indices, slices)), id: \.0) { index, slice in
                        PieSliceShape(
                            startAngle: startAngle(for: index),
                            endAngle: endAngle(for: index)
                        )
                        .fill(slice.color)
                    }
                    
                    // Center hole
                    Circle()
                        .fill(AppColors.cardBackground)
                        .frame(width: size * 0.5, height: size * 0.5)
                    
                    // Center text
                    VStack(spacing: 2) {
                        Text("\(Int(total))")
                            .font(AppTypography.headline)
                            .foregroundColor(AppColors.textPrimary)
                        Text("days")
                            .font(AppTypography.caption)
                            .foregroundColor(AppColors.textSecondary)
                    }
                }
                .frame(width: size, height: size)
            }
            .aspectRatio(1, contentMode: .fit)
            
            // Legend
            if showLegend {
                VStack(alignment: .leading, spacing: AppSpacing.sm) {
                    ForEach(slices) { slice in
                        HStack(spacing: AppSpacing.sm) {
                            Circle()
                                .fill(slice.color)
                                .frame(width: 12, height: 12)
                            
                            Text(slice.label)
                                .font(AppTypography.caption)
                                .foregroundColor(AppColors.textPrimary)
                            
                            Spacer()
                            
                            Text("\(Int(slice.value / total * 100))%")
                                .font(AppTypography.caption)
                                .foregroundColor(AppColors.textSecondary)
                        }
                    }
                }
                .frame(maxWidth: 120)
            }
        }
        .frame(height: 160)
    }
    
    private func startAngle(for index: Int) -> Angle {
        let precedingValue = slices.prefix(index).map { $0.value }.reduce(0, +)
        return .degrees(360 * precedingValue / total - 90)
    }
    
    private func endAngle(for index: Int) -> Angle {
        let cumulativeValue = slices.prefix(index + 1).map { $0.value }.reduce(0, +)
        return .degrees(360 * cumulativeValue / total - 90)
    }
}

struct PieSliceShape: Shape {
    let startAngle: Angle
    let endAngle: Angle
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        
        path.move(to: center)
        path.addArc(
            center: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: false
        )
        path.closeSubpath()
        
        return path
    }
}
