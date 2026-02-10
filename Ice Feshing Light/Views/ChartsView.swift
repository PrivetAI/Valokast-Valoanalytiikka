import SwiftUI

struct ChartsView: View {
    @ObservedObject var dataService: DataService
    
    @State private var selectedTab = 0
    
    let onNavigateToComparison: () -> Void
    let onNavigateBack: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: onNavigateBack) {
                    BackIcon(size: 24, color: AppColors.primary)
                }
                
                Spacer()
                
                Text("Charts")
                    .font(AppTypography.title)
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
                
                Button(action: onNavigateToComparison) {
                    CompareIcon(size: 24, color: AppColors.primary)
                }
            }
            .padding(.horizontal, AppSpacing.md)
            .padding(.vertical, AppSpacing.md)
            
            // Tab selector
            HStack(spacing: 0) {
                ChartTabButton(title: "Trend", isSelected: selectedTab == 0) {
                    selectedTab = 0
                }
                ChartTabButton(title: "Weather", isSelected: selectedTab == 1) {
                    selectedTab = 1
                }
                ChartTabButton(title: "Time", isSelected: selectedTab == 2) {
                    selectedTab = 2
                }
            }
            .padding(.horizontal, AppSpacing.md)
            
            // Chart content
            TabView(selection: $selectedTab) {
                TrendChartTab(dataService: dataService)
                    .tag(0)
                
                WeatherDistributionTab(dataService: dataService)
                    .tag(1)
                
                TimeEfficiencyTab(dataService: dataService)
                    .tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
        .background(AppColors.background.ignoresSafeArea())
    }
}

struct ChartTabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: AppSpacing.xs) {
                Text(title)
                    .font(AppTypography.callout)
                    .foregroundColor(isSelected ? AppColors.primary : AppColors.textSecondary)
                
                Rectangle()
                    .fill(isSelected ? AppColors.primary : Color.clear)
                    .frame(height: 3)
            }
        }
        .frame(maxWidth: .infinity)
        .buttonStyle(PlainButtonStyle())
    }
}

struct TrendChartTab: View {
    @ObservedObject var dataService: DataService
    
    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.lg) {
                CardView(title: "30-Day Catch Trend") {
                    let records = dataService.getLast30DaysRecords()
                    
                    if records.isEmpty {
                        EmptyChartMessage()
                    } else {
                        let dataPoints = records.map { record in
                            (date: record.date, value: Double(record.catchRating), weather: record.weather)
                        }
                        
                        LineChart(dataPoints: dataPoints)
                    }
                }
                .padding(.horizontal, AppSpacing.md)
                
                // Summary stats
                if !dataService.records.isEmpty {
                    let records = dataService.getLast30DaysRecords()
                    let avgRating = records.isEmpty ? 0 : Double(records.map { $0.catchRating }.reduce(0, +)) / Double(records.count)
                    let trend = calculateTrend(records)
                    
                    HStack(spacing: AppSpacing.md) {
                        StatCard(
                            title: "30-Day Avg",
                            value: String(format: "%.1f", avgRating),
                            color: ratingColor(avgRating)
                        )
                        
                        StatCard(
                            title: "Trend",
                            value: trend >= 0 ? "+\(String(format: "%.1f", trend))" : String(format: "%.1f", trend),
                            subtitle: trend >= 0 ? "Improving" : "Declining",
                            color: trend >= 0 ? AppColors.excellent : AppColors.danger
                        )
                    }
                    .padding(.horizontal, AppSpacing.md)
                }
                
                Spacer(minLength: AppSpacing.xl)
            }
            .padding(.top, AppSpacing.lg)
        }
    }
    
    private func calculateTrend(_ records: [FishingRecord]) -> Double {
        guard records.count >= 2 else { return 0 }
        
        let halfCount = records.count / 2
        let firstHalf = records.prefix(halfCount)
        let secondHalf = records.suffix(halfCount)
        
        let firstAvg = Double(firstHalf.map { $0.catchRating }.reduce(0, +)) / Double(firstHalf.count)
        let secondAvg = Double(secondHalf.map { $0.catchRating }.reduce(0, +)) / Double(secondHalf.count)
        
        return secondAvg - firstAvg
    }
    
    private func ratingColor(_ rating: Double) -> Color {
        if rating >= 8 { return AppColors.excellent }
        if rating >= 4 { return AppColors.average }
        return AppColors.poor
    }
}

struct WeatherDistributionTab: View {
    @ObservedObject var dataService: DataService
    
    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.lg) {
                CardView(title: "Weather Distribution") {
                    let weatherCounts = calculateWeatherCounts()
                    
                    if weatherCounts.isEmpty {
                        EmptyChartMessage()
                    } else {
                        let slices = weatherCounts.map { (condition, count) in
                            PieSlice(
                                label: condition.displayName,
                                value: Double(count),
                                color: weatherColor(condition)
                            )
                        }
                        
                        PieChart(slices: slices)
                    }
                }
                .padding(.horizontal, AppSpacing.md)
                
                // Weather breakdown
                if !dataService.records.isEmpty {
                    CardView(title: "Detailed Breakdown") {
                        let stats = dataService.getWeatherStats()
                        
                        VStack(spacing: AppSpacing.sm) {
                            ForEach(WeatherCondition.allCases) { condition in
                                if let stat = stats[condition] {
                                    HStack {
                                        WeatherIcon(condition: condition, size: 24)
                                        
                                        Text(condition.displayName)
                                            .font(AppTypography.callout)
                                            .foregroundColor(AppColors.textPrimary)
                                        
                                        Spacer()
                                        
                                        VStack(alignment: .trailing, spacing: 2) {
                                            Text("\(stat.daysCount) days")
                                                .font(AppTypography.callout)
                                                .foregroundColor(AppColors.textPrimary)
                                            
                                            Text("Avg: \(String(format: "%.1f", stat.averageRating))")
                                                .font(AppTypography.caption)
                                                .foregroundColor(AppColors.textSecondary)
                                        }
                                    }
                                    .padding(.vertical, AppSpacing.xs)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, AppSpacing.md)
                }
                
                Spacer(minLength: AppSpacing.xl)
            }
            .padding(.top, AppSpacing.lg)
        }
    }
    
    private func calculateWeatherCounts() -> [(WeatherCondition, Int)] {
        var counts: [WeatherCondition: Int] = [:]
        
        for record in dataService.records {
            counts[record.weather, default: 0] += 1
        }
        
        return counts.sorted { $0.value > $1.value }
    }
    
    private func weatherColor(_ condition: WeatherCondition) -> Color {
        switch condition {
        case .clear: return AppColors.sunny
        case .cloudy: return AppColors.cloudy
        case .overcast: return AppColors.overcast
        case .snowing: return AppColors.snowing
        }
    }
}

struct TimeEfficiencyTab: View {
    @ObservedObject var dataService: DataService
    
    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.lg) {
                CardView(title: "Avg Rating by Time") {
                    let stats = dataService.getTimeStats()
                    
                    if stats.isEmpty {
                        EmptyChartMessage()
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
                
                // Detailed time stats
                if !dataService.records.isEmpty {
                    CardView(title: "Time Analysis") {
                        let stats = dataService.getTimeStats()
                        
                        VStack(spacing: AppSpacing.sm) {
                            ForEach(TimeOfDay.allCases.sorted { time1, time2 in
                                (stats[time1]?.averageRating ?? 0) > (stats[time2]?.averageRating ?? 0)
                            }) { time in
                                if let stat = stats[time] {
                                    HStack {
                                        Circle()
                                            .fill(timeColor(time))
                                            .frame(width: 12, height: 12)
                                        
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(time.displayName)
                                                .font(AppTypography.callout)
                                                .foregroundColor(AppColors.textPrimary)
                                            
                                            Text(time.timeRange)
                                                .font(AppTypography.caption)
                                                .foregroundColor(AppColors.textSecondary)
                                        }
                                        
                                        Spacer()
                                        
                                        VStack(alignment: .trailing, spacing: 2) {
                                            Text(String(format: "%.1f", stat.averageRating))
                                                .font(AppTypography.headline)
                                                .foregroundColor(ratingColor(stat.averageRating))
                                            
                                            Text("\(Int(stat.successRate))% excellent")
                                                .font(AppTypography.caption)
                                                .foregroundColor(AppColors.textSecondary)
                                        }
                                    }
                                    .padding(.vertical, AppSpacing.xs)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, AppSpacing.md)
                }
                
                Spacer(minLength: AppSpacing.xl)
            }
            .padding(.top, AppSpacing.lg)
        }
    }
    
    private func timeColor(_ time: TimeOfDay) -> Color {
        switch time {
        case .morning: return AppColors.morning
        case .day: return AppColors.day
        case .evening: return AppColors.evening
        case .night: return AppColors.night
        }
    }
    
    private func ratingColor(_ rating: Double) -> Color {
        if rating >= 8 { return AppColors.excellent }
        if rating >= 4 { return AppColors.average }
        return AppColors.poor
    }
}

struct EmptyChartMessage: View {
    var body: some View {
        VStack(spacing: AppSpacing.md) {
            ChartIcon(size: 48, color: AppColors.textSecondary.opacity(0.5))
            
            Text("No data to display")
                .font(AppTypography.body)
                .foregroundColor(AppColors.textSecondary)
            
            Text("Start recording your fishing trips to see charts")
                .font(AppTypography.caption)
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(height: 180)
    }
}
