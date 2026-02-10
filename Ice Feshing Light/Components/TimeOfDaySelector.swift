import SwiftUI

struct TimeOfDayButton: View {
    let time: TimeOfDay
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: AppSpacing.xs) {
                Text(time.displayName)
                    .font(AppTypography.callout)
                    .foregroundColor(isSelected ? .white : AppColors.textPrimary)
                
                Text(time.timeRange)
                    .font(AppTypography.caption)
                    .foregroundColor(isSelected ? .white.opacity(0.8) : AppColors.textSecondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppSpacing.md)
            .background(
                RoundedRectangle(cornerRadius: AppCorners.medium)
                    .fill(isSelected ? timeColor : AppColors.surface)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var timeColor: Color {
        switch time {
        case .morning: return AppColors.morning
        case .day: return AppColors.day
        case .evening: return AppColors.evening
        case .night: return AppColors.night
        }
    }
}

struct TimeOfDaySelector: View {
    @Binding var selected: [TimeOfDay]
    
    var body: some View {
        VStack(spacing: AppSpacing.sm) {
            HStack(spacing: AppSpacing.sm) {
                TimeOfDayButton(
                    time: .morning,
                    isSelected: selected.contains(.morning)
                ) {
                    toggleTime(.morning)
                }
                
                TimeOfDayButton(
                    time: .day,
                    isSelected: selected.contains(.day)
                ) {
                    toggleTime(.day)
                }
            }
            
            HStack(spacing: AppSpacing.sm) {
                TimeOfDayButton(
                    time: .evening,
                    isSelected: selected.contains(.evening)
                ) {
                    toggleTime(.evening)
                }
                
                TimeOfDayButton(
                    time: .night,
                    isSelected: selected.contains(.night)
                ) {
                    toggleTime(.night)
                }
            }
        }
    }
    
    private func toggleTime(_ time: TimeOfDay) {
        if selected.contains(time) {
            selected.removeAll { $0 == time }
        } else {
            selected.append(time)
        }
    }
}
