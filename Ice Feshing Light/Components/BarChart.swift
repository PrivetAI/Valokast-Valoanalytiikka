import SwiftUI

struct BarChartData: Identifiable {
    let id = UUID()
    let label: String
    let value: Double
    let color: Color
}

struct BarChart: View {
    let data: [BarChartData]
    var maxValue: Double = 10
    var showLabels: Bool = true
    var showValues: Bool = true
    
    var body: some View {
        GeometryReader { geometry in
            let barWidth = (geometry.size.width - CGFloat(data.count - 1) * 12) / CGFloat(data.count)
            let maxHeight = geometry.size.height - (showLabels ? 40 : 0) - (showValues ? 25 : 0)
            
            HStack(alignment: .bottom, spacing: 12) {
                ForEach(data) { item in
                    VStack(spacing: 4) {
                        if showValues {
                            Text(String(format: "%.1f", item.value))
                                .font(AppTypography.caption)
                                .foregroundColor(AppColors.textSecondary)
                        }
                        
                        RoundedRectangle(cornerRadius: AppCorners.small)
                            .fill(item.color)
                            .frame(
                                width: barWidth,
                                height: max(4, CGFloat(item.value / maxValue) * maxHeight)
                            )
                        
                        if showLabels {
                            Text(item.label)
                                .font(AppTypography.caption)
                                .foregroundColor(AppColors.textSecondary)
                                .lineLimit(1)
                                .minimumScaleFactor(0.7)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        }
        .frame(height: 180)
    }
}

struct HorizontalBarChart: View {
    let data: [BarChartData]
    var maxValue: Double = 10
    
    var body: some View {
        VStack(spacing: AppSpacing.sm) {
            ForEach(data) { item in
                HStack(spacing: AppSpacing.sm) {
                    Text(item.label)
                        .font(AppTypography.callout)
                        .foregroundColor(AppColors.textPrimary)
                        .frame(width: 80, alignment: .leading)
                    
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(AppColors.surface)
                                .frame(height: 24)
                            
                            RoundedRectangle(cornerRadius: 4)
                                .fill(item.color)
                                .frame(
                                    width: max(4, CGFloat(item.value / maxValue) * geometry.size.width),
                                    height: 24
                                )
                        }
                    }
                    .frame(height: 24)
                    
                    Text(String(format: "%.1f", item.value))
                        .font(AppTypography.callout)
                        .foregroundColor(AppColors.textSecondary)
                        .frame(width: 40, alignment: .trailing)
                }
            }
        }
    }
}
