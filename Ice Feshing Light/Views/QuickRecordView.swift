import SwiftUI

struct QuickRecordView: View {
    @ObservedObject var dataService: DataService
    @ObservedObject var settingsService: SettingsService
    
    @State private var selectedWeather: WeatherCondition = .clear
    @State private var selectedTimes: [TimeOfDay] = []
    @State private var catchRating: Int = 5
    @State private var selectedFishIds: [UUID] = []
    @State private var biteCount: Int = 0
    @State private var caughtCount: Int = 0
    @State private var showSaveConfirmation = false
    
    let onNavigateToHistory: () -> Void
    
    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.lg) {
                // Header with date
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Today's Fishing")
                            .font(AppTypography.largeTitle)
                            .foregroundColor(AppColors.textPrimary)
                        
                        Text(formattedDate)
                            .font(AppTypography.body)
                            .foregroundColor(AppColors.textSecondary)
                    }
                    
                    Spacer()
                    
                    Button(action: onNavigateToHistory) {
                        HStack(spacing: AppSpacing.xs) {
                            CalendarIcon(size: 20, color: AppColors.primary)
                            Text("History")
                                .font(AppTypography.callout)
                                .foregroundColor(AppColors.primary)
                        }
                        .padding(.horizontal, AppSpacing.md)
                        .padding(.vertical, AppSpacing.sm)
                        .background(
                            RoundedRectangle(cornerRadius: AppCorners.medium)
                                .stroke(AppColors.primary, lineWidth: 1.5)
                        )
                    }
                }
                .padding(.horizontal, AppSpacing.md)
                
                // Weather selection
                CardView(title: "Lighting Conditions") {
                    WeatherButtonGroup(selected: $selectedWeather)
                }
                .padding(.horizontal, AppSpacing.md)
                
                // Time of day
                CardView(title: "Time of Day") {
                    TimeOfDaySelector(selected: $selectedTimes)
                }
                .padding(.horizontal, AppSpacing.md)
                
                // Catch rating
                CardView(title: "Catch Rating") {
                    CatchRatingView(rating: $catchRating)
                }
                .padding(.horizontal, AppSpacing.md)
                
                // Fish types
                CardView(title: "Fish Species") {
                    FishTypeSelector(
                        fishTypes: settingsService.fishTypes,
                        selectedIds: $selectedFishIds
                    )
                }
                .padding(.horizontal, AppSpacing.md)
                
                // Counts
                VStack(spacing: AppSpacing.sm) {
                    NumberInputField(title: "Number of Bites", value: $biteCount)
                    NumberInputField(title: "Fish Caught", value: $caughtCount)
                }
                .padding(.horizontal, AppSpacing.md)
                
                // Save button
                Button(action: saveRecord) {
                    HStack(spacing: AppSpacing.sm) {
                        SaveIcon(size: 22, color: .white)
                        Text("Save Record")
                    }
                }
                .buttonStyle(PrimaryButtonStyle())
                .padding(.horizontal, AppSpacing.md)
                .padding(.bottom, AppSpacing.xl)
            }
            .padding(.top, AppSpacing.md)
        }
        .background(AppColors.background.ignoresSafeArea())
        .overlay(
            Group {
                if showSaveConfirmation {
                    SaveConfirmationOverlay {
                        showSaveConfirmation = false
                    }
                }
            }
        )
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d, yyyy"
        return formatter.string(from: Date())
    }
    
    private func saveRecord() {
        let record = FishingRecord(
            date: Date(),
            weather: selectedWeather,
            timesOfDay: selectedTimes,
            catchRating: catchRating,
            fishTypeIds: selectedFishIds,
            biteCount: biteCount,
            caughtCount: caughtCount
        )
        
        dataService.saveRecord(record)
        
        // Reset form
        selectedWeather = .clear
        selectedTimes = []
        catchRating = 5
        selectedFishIds = []
        biteCount = 0
        caughtCount = 0
        
        showSaveConfirmation = true
    }
}

struct SaveConfirmationOverlay: View {
    let onDismiss: () -> Void
    
    @State private var opacity: Double = 0
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            VStack(spacing: AppSpacing.md) {
                ZStack {
                    Circle()
                        .fill(AppColors.excellent)
                        .frame(width: 60, height: 60)
                    
                    SaveIcon(size: 32, color: .white)
                }
                
                Text("Record Saved!")
                    .font(AppTypography.title)
                    .foregroundColor(AppColors.textPrimary)
                
                Text("Ready for next entry")
                    .font(AppTypography.body)
                    .foregroundColor(AppColors.textSecondary)
            }
            .padding(AppSpacing.xl)
            .background(AppColors.cardBackground)
            .cornerRadius(AppCorners.xl)
            .scaleEffect(opacity == 1 ? 1 : 0.8)
        }
        .opacity(opacity)
        .onAppear {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                opacity = 1
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation(.easeOut(duration: 0.2)) {
                    opacity = 0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    onDismiss()
                }
            }
        }
    }
}
