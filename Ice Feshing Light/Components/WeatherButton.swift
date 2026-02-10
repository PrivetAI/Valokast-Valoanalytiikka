import SwiftUI

struct WeatherButton: View {
    let condition: WeatherCondition
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: AppSpacing.sm) {
                ZStack {
                    Circle()
                        .fill(isSelected ? backgroundColor : AppColors.surface)
                        .frame(width: 64, height: 64)
                    
                    WeatherIcon(condition: condition, size: 36)
                }
                
                Text(condition.displayName)
                    .font(AppTypography.callout)
                    .foregroundColor(isSelected ? AppColors.primary : AppColors.textSecondary)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var backgroundColor: Color {
        switch condition {
        case .clear:
            return AppColors.sunny.opacity(0.2)
        case .cloudy:
            return AppColors.cloudy.opacity(0.3)
        case .overcast:
            return AppColors.overcast.opacity(0.3)
        case .snowing:
            return AppColors.snowing.opacity(0.4)
        }
    }
}

struct WeatherButtonGroup: View {
    @Binding var selected: WeatherCondition
    
    var body: some View {
        HStack(spacing: AppSpacing.md) {
            ForEach(WeatherCondition.allCases) { condition in
                WeatherButton(
                    condition: condition,
                    isSelected: selected == condition
                ) {
                    selected = condition
                }
            }
        }
    }
}
