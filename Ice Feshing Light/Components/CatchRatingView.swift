import SwiftUI

struct CatchRatingView: View {
    @Binding var rating: Int
    
    var body: some View {
        VStack(spacing: AppSpacing.md) {
            // Quick buttons
            HStack(spacing: AppSpacing.md) {
                RatingButton(
                    title: "Poor",
                    subtitle: "0-3",
                    isSelected: rating <= 3,
                    color: AppColors.poor
                ) {
                    rating = 2
                }
                
                RatingButton(
                    title: "Average",
                    subtitle: "4-7",
                    isSelected: rating >= 4 && rating <= 7,
                    color: AppColors.average
                ) {
                    rating = 5
                }
                
                RatingButton(
                    title: "Excellent",
                    subtitle: "8-10",
                    isSelected: rating >= 8,
                    color: AppColors.excellent
                ) {
                    rating = 9
                }
            }
            
            // Fine-tune slider
            VStack(spacing: AppSpacing.xs) {
                HStack {
                    Text("Fine-tune:")
                        .font(AppTypography.caption)
                        .foregroundColor(AppColors.textSecondary)
                    
                    Spacer()
                    
                    Text("\(rating)")
                        .font(AppTypography.headline)
                        .foregroundColor(ratingColor)
                }
                
                CustomSlider(value: $rating, range: 0...10)
            }
            .padding(.horizontal, AppSpacing.sm)
        }
    }
    
    private var ratingColor: Color {
        if rating >= 8 {
            return AppColors.excellent
        } else if rating >= 4 {
            return AppColors.average
        } else {
            return AppColors.poor
        }
    }
}

struct RatingButton: View {
    let title: String
    let subtitle: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: AppSpacing.xs) {
                Text(title)
                    .font(AppTypography.callout)
                    .foregroundColor(isSelected ? .white : AppColors.textPrimary)
                
                Text(subtitle)
                    .font(AppTypography.caption)
                    .foregroundColor(isSelected ? .white.opacity(0.8) : AppColors.textSecondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppSpacing.md)
            .background(
                RoundedRectangle(cornerRadius: AppCorners.medium)
                    .fill(isSelected ? color : AppColors.surface)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CustomSlider: View {
    @Binding var value: Int
    let range: ClosedRange<Int>
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Track
                RoundedRectangle(cornerRadius: 4)
                    .fill(AppColors.surface)
                    .frame(height: 8)
                
                // Fill
                RoundedRectangle(cornerRadius: 4)
                    .fill(fillColor)
                    .frame(width: fillWidth(in: geometry.size.width), height: 8)
                
                // Thumb
                Circle()
                    .fill(fillColor)
                    .frame(width: 24, height: 24)
                    .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
                    .offset(x: thumbOffset(in: geometry.size.width))
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { gesture in
                                updateValue(at: gesture.location.x, in: geometry.size.width)
                            }
                    )
            }
        }
        .frame(height: 24)
    }
    
    private var fillColor: Color {
        if value >= 8 {
            return AppColors.excellent
        } else if value >= 4 {
            return AppColors.average
        } else {
            return AppColors.poor
        }
    }
    
    private func fillWidth(in width: CGFloat) -> CGFloat {
        let percent = CGFloat(value - range.lowerBound) / CGFloat(range.upperBound - range.lowerBound)
        return max(0, percent * (width - 24) + 12)
    }
    
    private func thumbOffset(in width: CGFloat) -> CGFloat {
        let percent = CGFloat(value - range.lowerBound) / CGFloat(range.upperBound - range.lowerBound)
        return percent * (width - 24)
    }
    
    private func updateValue(at x: CGFloat, in width: CGFloat) {
        let percent = max(0, min(1, x / width))
        let newValue = Int(round(percent * CGFloat(range.upperBound - range.lowerBound))) + range.lowerBound
        value = max(range.lowerBound, min(range.upperBound, newValue))
    }
}
