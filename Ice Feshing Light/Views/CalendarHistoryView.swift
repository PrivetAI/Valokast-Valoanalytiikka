import SwiftUI

struct CalendarHistoryView: View {
    @ObservedObject var dataService: DataService
    @ObservedObject var settingsService: SettingsService
    
    @State private var selectedDate = Date()
    @State private var showingRecordDetail = false
    @State private var showingAddRecord = false
    @State private var selectedRecord: FishingRecord?
    
    let onNavigateToStats: () -> Void
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
                    
                    Text("Calendar")
                        .font(AppTypography.title)
                        .foregroundColor(AppColors.textPrimary)
                    
                    Spacer()
                    
                    Button(action: onNavigateToStats) {
                        StatsIcon(size: 24, color: AppColors.primary)
                    }
                }
                .padding(.horizontal, AppSpacing.md)
                
                // Calendar
                CalendarView(
                    selectedDate: $selectedDate,
                    records: dataService.records
                ) { date in
                    if let record = dataService.getRecord(for: date) {
                        selectedRecord = record
                        showingRecordDetail = true
                    }
                }
                .padding(.horizontal, AppSpacing.md)
                
                // Legend
                HStack(spacing: AppSpacing.lg) {
                    LegendItem(color: AppColors.excellent, label: "Excellent")
                    LegendItem(color: AppColors.average, label: "Average")
                    LegendItem(color: AppColors.poor, label: "Poor")
                }
                .padding(.horizontal, AppSpacing.md)
                
                // Add manual record button
                Button(action: { showingAddRecord = true }) {
                    HStack(spacing: AppSpacing.sm) {
                        PlusIcon(size: 18, color: AppColors.primary)
                        Text("Add Manual Record")
                    }
                }
                .buttonStyle(SecondaryButtonStyle())
                .padding(.horizontal, AppSpacing.md)
                
                // Recent records list
                if !dataService.records.isEmpty {
                    VStack(alignment: .leading, spacing: AppSpacing.md) {
                        Text("Recent Records")
                            .font(AppTypography.headline)
                            .foregroundColor(AppColors.textPrimary)
                            .padding(.horizontal, AppSpacing.md)
                        
                        ForEach(dataService.records.sorted { $0.date > $1.date }.prefix(5)) { record in
                            RecordRow(
                                record: record,
                                settingsService: settingsService
                            ) {
                                selectedRecord = record
                                showingRecordDetail = true
                            }
                            .padding(.horizontal, AppSpacing.md)
                        }
                    }
                }
                
                Spacer(minLength: AppSpacing.xl)
            }
            .padding(.top, AppSpacing.md)
        }
        .background(AppColors.background.ignoresSafeArea())
        .sheet(isPresented: $showingRecordDetail) {
            if let record = selectedRecord {
                RecordDetailSheet(
                    record: record,
                    settingsService: settingsService,
                    onSave: { updatedRecord in
                        dataService.saveRecord(updatedRecord)
                        showingRecordDetail = false
                    },
                    onDelete: {
                        dataService.deleteRecord(record)
                        showingRecordDetail = false
                    },
                    onDismiss: {
                        showingRecordDetail = false
                    }
                )
            }
        }
        .sheet(isPresented: $showingAddRecord) {
            AddRecordSheet(
                settingsService: settingsService,
                onSave: { newRecord in
                    dataService.saveRecord(newRecord)
                    showingAddRecord = false
                },
                onDismiss: {
                    showingAddRecord = false
                }
            )
        }
    }
}

struct LegendItem: View {
    let color: Color
    let label: String
    
    var body: some View {
        HStack(spacing: AppSpacing.xs) {
            RoundedRectangle(cornerRadius: 4)
                .fill(color.opacity(0.3))
                .frame(width: 20, height: 20)
            
            Text(label)
                .font(AppTypography.caption)
                .foregroundColor(AppColors.textSecondary)
        }
    }
}

struct RecordRow: View {
    let record: FishingRecord
    let settingsService: SettingsService
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: AppSpacing.md) {
                // Date and weather
                VStack(alignment: .leading, spacing: 4) {
                    Text(formattedDate)
                        .font(AppTypography.callout)
                        .foregroundColor(AppColors.textPrimary)
                    
                    HStack(spacing: AppSpacing.xs) {
                        WeatherIcon(condition: record.weather, size: 16)
                        
                        Text(record.timesOfDay.map { $0.displayName }.joined(separator: ", "))
                            .font(AppTypography.caption)
                            .foregroundColor(AppColors.textSecondary)
                    }
                }
                
                Spacer()
                
                // Rating badge
                Text("\(record.catchRating)")
                    .font(AppTypography.headline)
                    .foregroundColor(.white)
                    .frame(width: 36, height: 36)
                    .background(
                        Circle()
                            .fill(ratingColor)
                    )
            }
            .padding(AppSpacing.md)
            .background(AppColors.cardBackground)
            .cornerRadius(AppCorners.medium)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: record.date)
    }
    
    private var ratingColor: Color {
        switch record.ratingCategory {
        case .excellent: return AppColors.excellent
        case .average: return AppColors.average
        case .poor: return AppColors.poor
        }
    }
}

struct RecordDetailSheet: View {
    @State var record: FishingRecord
    let settingsService: SettingsService
    let onSave: (FishingRecord) -> Void
    let onDelete: () -> Void
    let onDismiss: () -> Void
    
    @State private var showDeleteConfirmation = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: AppSpacing.lg) {
                    // Date display
                    HStack {
                        Text(formattedDate)
                            .font(AppTypography.title)
                            .foregroundColor(AppColors.textPrimary)
                        Spacer()
                    }
                    .padding(.horizontal, AppSpacing.md)
                    
                    // Weather
                    CardView(title: "Weather") {
                        WeatherButtonGroup(selected: $record.weather)
                    }
                    .padding(.horizontal, AppSpacing.md)
                    
                    // Time
                    CardView(title: "Time of Day") {
                        TimeOfDaySelector(selected: $record.timesOfDay)
                    }
                    .padding(.horizontal, AppSpacing.md)
                    
                    // Rating
                    CardView(title: "Catch Rating") {
                        CatchRatingView(rating: $record.catchRating)
                    }
                    .padding(.horizontal, AppSpacing.md)
                    
                    // Fish
                    CardView(title: "Fish Species") {
                        FishTypeSelector(
                            fishTypes: settingsService.fishTypes,
                            selectedIds: $record.fishTypeIds
                        )
                    }
                    .padding(.horizontal, AppSpacing.md)
                    
                    // Counts
                    VStack(spacing: AppSpacing.sm) {
                        NumberInputField(title: "Number of Bites", value: $record.biteCount)
                        NumberInputField(title: "Fish Caught", value: $record.caughtCount)
                    }
                    .padding(.horizontal, AppSpacing.md)
                    
                    // Delete button
                    Button(action: { showDeleteConfirmation = true }) {
                        HStack(spacing: AppSpacing.sm) {
                            DeleteIcon(size: 18, color: AppColors.danger)
                            Text("Delete Record")
                                .foregroundColor(AppColors.danger)
                        }
                    }
                    .padding(.top, AppSpacing.md)
                    
                    Spacer(minLength: AppSpacing.xl)
                }
                .padding(.top, AppSpacing.md)
            }
            .background(AppColors.background.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        onDismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        onSave(record)
                    }
                    .fontWeight(.semibold)
                }
            }
            .alert(isPresented: $showDeleteConfirmation) {
                Alert(
                    title: Text("Delete Record?"),
                    message: Text("This action cannot be undone."),
                    primaryButton: .destructive(Text("Delete")) {
                        onDelete()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d, yyyy"
        return formatter.string(from: record.date)
    }
}

struct AddRecordSheet: View {
    let settingsService: SettingsService
    let onSave: (FishingRecord) -> Void
    let onDismiss: () -> Void
    
    @State private var selectedDate = Date()
    @State private var selectedWeather: WeatherCondition = .clear
    @State private var selectedTimes: [TimeOfDay] = []
    @State private var catchRating: Int = 5
    @State private var selectedFishIds: [UUID] = []
    @State private var biteCount: Int = 0
    @State private var caughtCount: Int = 0
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: AppSpacing.lg) {
                    // Date picker
                    CardView(title: "Date") {
                        DatePicker(
                            "",
                            selection: $selectedDate,
                            displayedComponents: .date
                        )
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .accentColor(AppColors.primary)
                    }
                    .padding(.horizontal, AppSpacing.md)
                    
                    // Weather
                    CardView(title: "Weather") {
                        WeatherButtonGroup(selected: $selectedWeather)
                    }
                    .padding(.horizontal, AppSpacing.md)
                    
                    // Time
                    CardView(title: "Time of Day") {
                        TimeOfDaySelector(selected: $selectedTimes)
                    }
                    .padding(.horizontal, AppSpacing.md)
                    
                    // Rating
                    CardView(title: "Catch Rating") {
                        CatchRatingView(rating: $catchRating)
                    }
                    .padding(.horizontal, AppSpacing.md)
                    
                    // Fish
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
                    
                    Spacer(minLength: AppSpacing.xl)
                }
                .padding(.top, AppSpacing.md)
            }
            .background(AppColors.background.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Add Record")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        onDismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let record = FishingRecord(
                            date: selectedDate,
                            weather: selectedWeather,
                            timesOfDay: selectedTimes,
                            catchRating: catchRating,
                            fishTypeIds: selectedFishIds,
                            biteCount: biteCount,
                            caughtCount: caughtCount
                        )
                        onSave(record)
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
}
