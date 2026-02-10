import SwiftUI

struct NumberInputField: View {
    let title: String
    @Binding var value: Int
    var minValue: Int = 0
    var maxValue: Int = 999
    
    var body: some View {
        HStack {
            Text(title)
                .font(AppTypography.body)
                .foregroundColor(AppColors.textPrimary)
            
            Spacer()
            
            HStack(spacing: 0) {
                // Minus button
                Button(action: {
                    if value > minValue {
                        value -= 1
                    }
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: AppCorners.small)
                            .fill(AppColors.surface)
                            .frame(width: 44, height: 44)
                        
                        Rectangle()
                            .fill(AppColors.textSecondary)
                            .frame(width: 16, height: 3)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                
                // Value display
                Text("\(value)")
                    .font(AppTypography.headline)
                    .foregroundColor(AppColors.textPrimary)
                    .frame(width: 60)
                    .multilineTextAlignment(.center)
                
                // Plus button
                Button(action: {
                    if value < maxValue {
                        value += 1
                    }
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: AppCorners.small)
                            .fill(AppColors.primary)
                            .frame(width: 44, height: 44)
                        
                        PlusIcon(size: 18, color: .white)
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(AppSpacing.md)
        .background(
            RoundedRectangle(cornerRadius: AppCorners.medium)
                .fill(AppColors.cardBackground)
        )
    }
}
