import SwiftUI

struct SettingsView: View {
    @ObservedObject var settingsService: SettingsService
    
    @State private var showAddFish = false
    @State private var newFishName = ""
    @State private var showResetConfirmation = false
    
    let onNavigateBack: () -> Void
    
    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.lg) {
                // Header
                HStack {
                    Button(action: onNavigateBack) {
                        BackIcon(size: 24, color: AppColors.primary)
                    }
                    
                    Spacer()
                    
                    Text("Settings")
                        .font(AppTypography.title)
                        .foregroundColor(AppColors.textPrimary)
                    
                    Spacer()
                    
                    // Placeholder for alignment
                    Color.clear.frame(width: 24, height: 24)
                }
                .padding(.horizontal, AppSpacing.md)
                
                // Fish Types section
                CardView(title: "Fish Species") {
                    VStack(spacing: AppSpacing.sm) {
                        ForEach(settingsService.fishTypes) { fish in
                            HStack {
                                Text(fish.name)
                                    .font(AppTypography.body)
                                    .foregroundColor(AppColors.textPrimary)
                                
                                if fish.isCustom {
                                    Text("Custom")
                                        .font(AppTypography.caption)
                                        .foregroundColor(AppColors.textSecondary)
                                        .padding(.horizontal, AppSpacing.xs)
                                        .padding(.vertical, 2)
                                        .background(AppColors.surface)
                                        .cornerRadius(4)
                                }
                                
                                Spacer()
                                
                                if fish.isCustom {
                                    Button(action: {
                                        settingsService.removeFishType(fish)
                                    }) {
                                        DeleteIcon(size: 18, color: AppColors.danger)
                                    }
                                }
                            }
                            .padding(.vertical, AppSpacing.xs)
                        }
                        
                        // Add fish button
                        if showAddFish {
                            HStack {
                                TextField("Fish name", text: $newFishName)
                                    .font(AppTypography.body)
                                    .padding(AppSpacing.sm)
                                    .background(AppColors.surface)
                                    .cornerRadius(AppCorners.small)
                                
                                Button(action: addFish) {
                                    Text("Add")
                                        .font(AppTypography.callout)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, AppSpacing.md)
                                        .padding(.vertical, AppSpacing.sm)
                                        .background(AppColors.primary)
                                        .cornerRadius(AppCorners.small)
                                }
                                
                                Button(action: { showAddFish = false }) {
                                    Text("Cancel")
                                        .font(AppTypography.callout)
                                        .foregroundColor(AppColors.textSecondary)
                                }
                            }
                        } else {
                            Button(action: { showAddFish = true }) {
                                HStack(spacing: AppSpacing.xs) {
                                    PlusIcon(size: 16, color: AppColors.primary)
                                    Text("Add Custom Fish")
                                        .font(AppTypography.callout)
                                        .foregroundColor(AppColors.primary)
                                }
                            }
                            .padding(.top, AppSpacing.sm)
                        }
                    }
                }
                .padding(.horizontal, AppSpacing.md)
                
                // Time Boundaries section
                CardView(title: "Time of Day Boundaries") {
                    VStack(spacing: AppSpacing.md) {
                        TimeBoundaryRow(
                            title: "Morning",
                            startHour: $settingsService.timeBoundaries.morningStart,
                            endHour: $settingsService.timeBoundaries.morningEnd,
                            color: AppColors.morning
                        )
                        
                        TimeBoundaryRow(
                            title: "Day",
                            startHour: $settingsService.timeBoundaries.dayStart,
                            endHour: $settingsService.timeBoundaries.dayEnd,
                            color: AppColors.day
                        )
                        
                        TimeBoundaryRow(
                            title: "Evening",
                            startHour: $settingsService.timeBoundaries.eveningStart,
                            endHour: $settingsService.timeBoundaries.eveningEnd,
                            color: AppColors.evening
                        )
                        
                        TimeBoundaryRow(
                            title: "Night",
                            startHour: $settingsService.timeBoundaries.nightStart,
                            endHour: $settingsService.timeBoundaries.nightEnd,
                            color: AppColors.night
                        )
                    }
                }
                .padding(.horizontal, AppSpacing.md)
                
                // About section
                CardView(title: "About") {
                    VStack(alignment: .leading, spacing: AppSpacing.sm) {
                        HStack {
                            Text("Version")
                                .font(AppTypography.body)
                                .foregroundColor(AppColors.textPrimary)
                            Spacer()
                            Text("1.0")
                                .font(AppTypography.body)
                                .foregroundColor(AppColors.textSecondary)
                        }
                        
                        Divider()
                        
                        Text("Ice Feshing Light helps you track lighting conditions, weather, and fishing success to find correlations through long-term observations.")
                            .font(AppTypography.caption)
                            .foregroundColor(AppColors.textSecondary)
                    }
                }
                .padding(.horizontal, AppSpacing.md)
                
                // Reset Data section
                CardView {
                    Button(action: { showResetConfirmation = true }) {
                        HStack {
                            DeleteIcon(size: 20, color: AppColors.danger)
                            
                            Text("Reset All Data")
                                .font(AppTypography.body)
                                .foregroundColor(AppColors.danger)
                            
                            Spacer()
                        }
                    }
                }
                .padding(.horizontal, AppSpacing.md)
                
                Spacer(minLength: AppSpacing.xl)
            }
            .padding(.top, AppSpacing.md)
        }
        .background(AppColors.background.ignoresSafeArea())
        .alert(isPresented: $showResetConfirmation) {
            Alert(
                title: Text("Reset All Data?"),
                message: Text("This will delete all your fishing records and custom settings. This action cannot be undone."),
                primaryButton: .destructive(Text("Reset")) {
                    settingsService.resetAllData()
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    private func addFish() {
        guard !newFishName.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        settingsService.addFishType(name: newFishName)
        newFishName = ""
        showAddFish = false
    }
}

struct TimeBoundaryRow: View {
    let title: String
    @Binding var startHour: Int
    @Binding var endHour: Int
    let color: Color
    
    var body: some View {
        HStack {
            Circle()
                .fill(color)
                .frame(width: 12, height: 12)
            
            Text(title)
                .font(AppTypography.callout)
                .foregroundColor(AppColors.textPrimary)
            
            Spacer()
            
            HStack(spacing: AppSpacing.xs) {
                HourPicker(hour: $startHour)
                
                Text("-")
                    .foregroundColor(AppColors.textSecondary)
                
                HourPicker(hour: $endHour)
            }
        }
    }
}

struct HourPicker: View {
    @Binding var hour: Int
    
    var body: some View {
        Menu {
            ForEach(0..<24) { h in
                Button(action: { hour = h }) {
                    Text(String(format: "%02d:00", h))
                }
            }
        } label: {
            Text(String(format: "%02d:00", hour))
                .font(AppTypography.callout)
                .foregroundColor(AppColors.textPrimary)
                .padding(.horizontal, AppSpacing.sm)
                .padding(.vertical, AppSpacing.xs)
                .background(AppColors.surface)
                .cornerRadius(AppCorners.small)
        }
    }
}
