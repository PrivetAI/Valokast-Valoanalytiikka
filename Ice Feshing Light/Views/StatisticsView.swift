import SwiftUI

struct StatisticsView: View {
    @ObservedObject var dataService: DataService
    @ObservedObject var settingsService: SettingsService
    
    let onNavigateToCharts: () -> Void
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
                    
                    Text("Statistics")
                        .font(AppTypography.title)
                        .foregroundColor(AppColors.textPrimary)
                    
                    Spacer()
                    
                    Button(action: onNavigateToCharts) {
                        ChartIcon(size: 24, color: AppColors.primary)
                    }
                }
                .padding(.horizontal, AppSpacing.md)
                
                // Weather and Catch section
                WeatherStatsSection(stats: dataService.getWeatherStats())
                
                // Time of Day section
                TimeStatsSection(stats: dataService.getTimeStats())
                
                // Fish Stats section
                FishStatsSection(
                    stats: dataService.getFishStats(fishTypes: settingsService.fishTypes),
                    fishTypes: settingsService.fishTypes
                )
                
                // Overall Stats section
                OverallStatsSection(stats: dataService.getOverallStats())
                
                // Recommendations section
                RecommendationsSection(
                    recommendations: dataService.getRecommendations(fishTypes: settingsService.fishTypes)
                )
                
                Spacer(minLength: AppSpacing.xl)
            }
            .padding(.top, AppSpacing.md)
        }
        .background(AppColors.background.ignoresSafeArea())
    }
}

struct WeatherStatsSection: View {
    let stats: [WeatherCondition: WeatherStats]
    
    var body: some View {
        CardView(title: "Weather & Catch") {
            if stats.isEmpty {
                EmptyStatsMessage()
            } else {
                VStack(spacing: AppSpacing.md) {
                    HStack(spacing: AppSpacing.sm) {
                        ForEach(WeatherCondition.allCases) { condition in
                            if let stat = stats[condition] {
                                WeatherStatColumn(condition: condition, stat: stat)
                            } else {
                                WeatherStatColumn(condition: condition, stat: nil)
                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal, AppSpacing.md)
    }
}

struct WeatherStatColumn: View {
    let condition: WeatherCondition
    let stat: WeatherStats?
    
    var body: some View {
        VStack(spacing: AppSpacing.xs) {
            WeatherIcon(condition: condition, size: 28)
            
            if let stat = stat {
                Text("\(stat.daysCount)")
                    .font(AppTypography.headline)
                    .foregroundColor(AppColors.textPrimary)
                
                Text("days")
                    .font(AppTypography.caption)
                    .foregroundColor(AppColors.textSecondary)
                
                Text(String(format: "%.1f", stat.averageRating))
                    .font(AppTypography.callout)
                    .foregroundColor(ratingColor(stat.averageRating))
                
                Text("\(Int(stat.successRate))%")
                    .font(AppTypography.caption)
                    .foregroundColor(AppColors.excellent)
            } else {
                Text("-")
                    .font(AppTypography.headline)
                    .foregroundColor(AppColors.textSecondary)
                
                Text("days")
                    .font(AppTypography.caption)
                    .foregroundColor(AppColors.textSecondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, AppSpacing.sm)
        .background(AppColors.surface)
        .cornerRadius(AppCorners.medium)
    }
    
    private func ratingColor(_ rating: Double) -> Color {
        if rating >= 8 { return AppColors.excellent }
        if rating >= 4 { return AppColors.average }
        return AppColors.poor
    }
}

struct TimeStatsSection: View {
    let stats: [TimeOfDay: TimeStats]
    
    var body: some View {
        CardView(title: "Time of Day") {
            if stats.isEmpty {
                EmptyStatsMessage()
            } else {
                let data = TimeOfDay.allCases.compactMap { time -> BarChartData? in
                    guard let stat = stats[time] else { return nil }
                    return BarChartData(
                        label: time.displayName,
                        value: stat.averageRating,
                        color: timeColor(time)
                    )
                }
                
                if !data.isEmpty {
                    BarChart(data: data)
                }
            }
        }
        .padding(.horizontal, AppSpacing.md)
    }
    
    private func timeColor(_ time: TimeOfDay) -> Color {
        switch time {
        case .morning: return AppColors.morning
        case .day: return AppColors.day
        case .evening: return AppColors.evening
        case .night: return AppColors.night
        }
    }
}

struct FishStatsSection: View {
    let stats: [UUID: FishStats]
    let fishTypes: [FishType]
    
    var body: some View {
        CardView(title: "By Fish Species") {
            if stats.isEmpty {
                EmptyStatsMessage()
            } else {
                VStack(spacing: AppSpacing.sm) {
                    ForEach(fishTypes.filter { stats[$0.id] != nil }) { fish in
                        if let stat = stats[fish.id] {
                            FishStatRow(fish: fish, stat: stat)
                        }
                    }
                }
            }
        }
        .padding(.horizontal, AppSpacing.md)
    }
}

struct FishStatRow: View {
    let fish: FishType
    let stat: FishStats
    
    var body: some View {
        HStack(spacing: AppSpacing.md) {
            VStack(alignment: .leading, spacing: 2) {
                Text(fish.name)
                    .font(AppTypography.callout)
                    .foregroundColor(AppColors.textPrimary)
                
                HStack(spacing: AppSpacing.xs) {
                    Text("\(stat.daysCount) days")
                        .font(AppTypography.caption)
                        .foregroundColor(AppColors.textSecondary)
                    
                    if let weather = stat.bestWeather {
                        Text("•")
                            .foregroundColor(AppColors.textSecondary)
                        WeatherIcon(condition: weather, size: 14)
                    }
                    
                    if let time = stat.bestTime {
                        Text(time.displayName)
                            .font(AppTypography.caption)
                            .foregroundColor(AppColors.textSecondary)
                    }
                }
            }
            
            Spacer()
            
            Text(String(format: "%.1f", stat.averageRating))
                .font(AppTypography.headline)
                .foregroundColor(ratingColor)
        }
        .padding(AppSpacing.sm)
        .background(AppColors.surface)
        .cornerRadius(AppCorners.small)
    }
    
    private var ratingColor: Color {
        if stat.averageRating >= 8 { return AppColors.excellent }
        if stat.averageRating >= 4 { return AppColors.average }
        return AppColors.poor
    }
}

struct OverallStatsSection: View {
    let stats: OverallStats
    
    var body: some View {
        CardView(title: "Season Summary") {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: AppSpacing.md) {
                StatCard(
                    title: "Days on Ice",
                    value: "\(stats.totalDays)",
                    color: AppColors.primary
                )
                
                StatCard(
                    title: "Total Bites",
                    value: "\(stats.totalBites)",
                    color: AppColors.accent
                )
                
                StatCard(
                    title: "Fish Caught",
                    value: "\(stats.totalCaught)",
                    color: AppColors.excellent
                )
                
                StatCard(
                    title: "Avg Rating",
                    value: String(format: "%.1f", stats.averageRating),
                    color: ratingColor
                )
            }
            
            if let bestDay = stats.bestDay {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Best Day")
                            .font(AppTypography.caption)
                            .foregroundColor(AppColors.textSecondary)
                        
                        Text(formattedDate(bestDay.date))
                            .font(AppTypography.callout)
                            .foregroundColor(AppColors.textPrimary)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: AppSpacing.xs) {
                        WeatherIcon(condition: bestDay.weather, size: 20)
                        
                        Text("\(bestDay.catchRating)")
                            .font(AppTypography.headline)
                            .foregroundColor(AppColors.excellent)
                    }
                }
                .padding(AppSpacing.md)
                .background(AppColors.excellent.opacity(0.1))
                .cornerRadius(AppCorners.medium)
            }
        }
        .padding(.horizontal, AppSpacing.md)
    }
    
    private var ratingColor: Color {
        if stats.averageRating >= 8 { return AppColors.excellent }
        if stats.averageRating >= 4 { return AppColors.average }
        return AppColors.poor
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }
}

struct RecommendationsSection: View {
    let recommendations: [String]
    
    var body: some View {
        if !recommendations.isEmpty {
            CardView(title: "Recommendations") {
                VStack(spacing: AppSpacing.sm) {
                    ForEach(recommendations, id: \.self) { recommendation in
                        RecommendationCard(text: recommendation)
                    }
                }
            }
            .padding(.horizontal, AppSpacing.md)
        }
    }
}

struct EmptyStatsMessage: View {
    var body: some View {
        Text("No data yet. Start recording your fishing trips!")
            .font(AppTypography.body)
            .foregroundColor(AppColors.textSecondary)
            .multilineTextAlignment(.center)
            .padding(AppSpacing.lg)
    }
}
