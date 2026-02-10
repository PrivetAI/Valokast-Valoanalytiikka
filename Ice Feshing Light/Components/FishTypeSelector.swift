import SwiftUI

struct FishTypeChip: View {
    let fish: FishType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.xs) {
                if isSelected {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 8, height: 8)
                }
                
                Text(fish.name)
                    .font(AppTypography.callout)
                    .foregroundColor(isSelected ? .white : AppColors.textPrimary)
            }
            .padding(.horizontal, AppSpacing.md)
            .padding(.vertical, AppSpacing.sm)
            .background(
                RoundedRectangle(cornerRadius: AppCorners.xl)
                    .fill(isSelected ? AppColors.primary : AppColors.surface)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct FishTypeSelector: View {
    let fishTypes: [FishType]
    @Binding var selectedIds: [UUID]
    
    private let columns = [
        GridItem(.adaptive(minimum: 90), spacing: AppSpacing.sm)
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: AppSpacing.sm) {
            ForEach(fishTypes) { fish in
                FishTypeChip(
                    fish: fish,
                    isSelected: selectedIds.contains(fish.id)
                ) {
                    toggleFish(fish.id)
                }
            }
        }
    }
    
    private func toggleFish(_ id: UUID) {
        if selectedIds.contains(id) {
            selectedIds.removeAll { $0 == id }
        } else {
            selectedIds.append(id)
        }
    }
}
