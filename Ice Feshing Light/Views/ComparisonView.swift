import SwiftUI

struct ComparisonView: View {
    @ObservedObject var dataService: DataService
    
    @State private var condition1Weather: WeatherCondition = .clear
    @State private var condition1Time: TimeOfDay = .morning
    @State private var condition2Weather: WeatherCondition = .overcast
    @State private var condition2Time: TimeOfDay = .morning
    
    let onNavigateToSettings: () -> Void
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
                    
                    Text("Compare")
                        .font(AppTypography.title)
                        .foregroundColor(AppColors.textPrimary)
                    
                    Spacer()
                    
                    Button(action: onNavigateToSettings) {
                        SettingsIcon(size: 24, color: AppColors.primary)
                    }
                }
                .padding(.horizontal, AppSpacing.md)
                
                // Condition 1 selector
                ConditionSelector(
                    title: "Condition A",
                    weather: $condition1Weather,
                    time: $condition1Time,
                    color: AppColors.primary
                )
                .padding(.horizontal, AppSpacing.md)
                
                // VS divider
                HStack {
                    Rectangle()
                        .fill(AppColors.surface)
                        .frame(height: 2)
                    
                    Text("VS")
                        .font(AppTypography.headline)
                        .foregroundColor(AppColors.textSecondary)
                        .padding(.horizontal, AppSpacing.md)
                    
                    Rectangle()
                        .fill(AppColors.surface)
                        .frame(height: 2)
                }
                .padding(.horizontal, AppSpacing.lg)
                
                // Condition 2 selector
                ConditionSelector(
                    title: "Condition B",
                    weather: $condition2Weather,
                    time: $condition2Time,
                    color: AppColors.accent
                )
                .padding(.horizontal, AppSpacing.md)
                
                // Comparison results
                ComparisonResults(
                    stats1: dataService.getConditionStats(weather: condition1Weather, time: condition1Time),
                    stats2: dataService.getConditionStats(weather: condition2Weather, time: condition2Time),
                    label1: "\(condition1Weather.shortName) + \(condition1Time.displayName)",
                    label2: "\(condition2Weather.shortName) + \(condition2Time.displayName)"
                )
                .padding(.horizontal, AppSpacing.md)
                
                // Recommendation
                if let recommendation = generateRecommendation() {
                    CardView(title: "Recommendation") {
                        RecommendationCard(text: recommendation)
                    }
                    .padding(.horizontal, AppSpacing.md)
                }
                
                Spacer(minLength: AppSpacing.xl)
            }
            .padding(.top, AppSpacing.md)
        }
        .background(AppColors.background.ignoresSafeArea())
    }
    
    private func generateRecommendation() -> String? {
        let stats1 = dataService.getConditionStats(weather: condition1Weather, time: condition1Time)
        let stats2 = dataService.getConditionStats(weather: condition2Weather, time: condition2Time)
        
        guard stats1.timesInCondition > 0 || stats2.timesInCondition > 0 else {
            return nil
        }
        
        if stats1.timesInCondition == 0 {
            return "You haven't fished during \(condition1Weather.displayName.lowercased()) \(condition1Time.displayName.lowercased()) yet. Try it to compare!"
        }
        
        if stats2.timesInCondition == 0 {
            return "You haven't fished during \(condition2Weather.displayName.lowercased()) \(condition2Time.displayName.lowercased()) yet. Try it to compare!"
        }
        
        let diff = stats1.averageRating - stats2.averageRating
        
        if abs(diff) < 0.5 {
            return "Both conditions perform similarly. Choose based on your preference!"
        } else if diff > 0 {
            return "\(condition1Weather.displayName) \(condition1Time.displayName.lowercased()) is your better choice with \(String(format: "%.1f", diff)) higher average rating."
        } else {
            return "\(condition2Weather.displayName) \(condition2Time.displayName.lowercased()) is your better choice with \(String(format: "%.1f", abs(diff))) higher average rating."
        }
    }
}

struct ConditionSelector: View {
    let title: String
    @Binding var weather: WeatherCondition
    @Binding var time: TimeOfDay
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            HStack {
                Circle()
                    .fill(color)
                    .frame(width: 12, height: 12)
                
                Text(title)
                    .font(AppTypography.headline)
                    .foregroundColor(AppColors.textPrimary)
            }
            
            VStack(spacing: AppSpacing.sm) {
                // Weather picker
                HStack(spacing: AppSpacing.sm) {
                    ForEach(WeatherCondition.allCases) { condition in
                        Button(action: { weather = condition }) {
                            ZStack {
                                Circle()
                                    .fill(weather == condition ? color.opacity(0.2) : AppColors.surface)
                                    .frame(width: 48, height: 48)
                                
                                WeatherIcon(condition: condition, size: 24)
                            }
                            .overlay(
                                Circle()
                                    .stroke(weather == condition ? color : Color.clear, lineWidth: 2)
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                
                // Time picker
                HStack(spacing: AppSpacing.sm) {
                    ForEach(TimeOfDay.allCases) { timeOfDay in
                        Button(action: { time = timeOfDay }) {
                            Text(timeOfDay.displayName)
                                .font(AppTypography.caption)
                                .foregroundColor(time == timeOfDay ? .white : AppColors.textSecondary)
                                .padding(.horizontal, AppSpacing.sm)
                                .padding(.vertical, AppSpacing.xs)
                                .background(
                                    RoundedRectangle(cornerRadius: AppCorners.small)
                                        .fill(time == timeOfDay ? color : AppColors.surface)
                                )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
        .padding(AppSpacing.md)
        .background(AppColors.cardBackground)
        .cornerRadius(AppCorners.large)
        .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
    }
}

struct ComparisonResults: View {
    let stats1: ConditionStats
    let stats2: ConditionStats
    let label1: String
    let label2: String
    
    var body: some View {
        VStack(spacing: AppSpacing.md) {
            // Comparison bars
            ComparisonRow(
                title: "Times Fished",
                value1: Double(stats1.timesInCondition),
                value2: Double(stats2.timesInCondition),
                format: "%.0f",
                maxValue: Double(max(stats1.timesInCondition, stats2.timesInCondition, 1))
            )
            
            ComparisonRow(
                title: "Average Rating",
                value1: stats1.averageRating,
                value2: stats2.averageRating,
                format: "%.1f",
                maxValue: 10
            )
            
            // Best days
            HStack(spacing: AppSpacing.md) {
                BestDayCard(label: label1, record: stats1.bestDay)
                BestDayCard(label: label2, record: stats2.bestDay)
            }
        }
        .padding(AppSpacing.md)
        .background(AppColors.cardBackground)
        .cornerRadius(AppCorners.large)
        .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
    }
}

struct ComparisonRow: View {
    let title: String
    let value1: Double
    let value2: Double
    let format: String
    let maxValue: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            Text(title)
                .font(AppTypography.caption)
                .foregroundColor(AppColors.textSecondary)
            
            HStack(spacing: AppSpacing.sm) {
                // Value 1
                Text(String(format: format, value1))
                    .font(AppTypography.callout)
                    .foregroundColor(AppColors.textPrimary)
                    .frame(width: 40, alignment: .trailing)
                
                // Bar 1
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 3)
                            .fill(AppColors.surface)
                        
                        RoundedRectangle(cornerRadius: 3)
                            .fill(AppColors.primary)
                            .frame(width: max(4, geometry.size.width * CGFloat(value1 / maxValue)))
                    }
                }
                .frame(height: 12)
                
                // Bar 2
                GeometryReader { geometry in
                    ZStack(alignment: .trailing) {
                        RoundedRectangle(cornerRadius: 3)
                            .fill(AppColors.surface)
                        
                        RoundedRectangle(cornerRadius: 3)
                            .fill(AppColors.accent)
                            .frame(width: max(4, geometry.size.width * CGFloat(value2 / maxValue)))
                    }
                }
                .frame(height: 12)
                
                // Value 2
                Text(String(format: format, value2))
                    .font(AppTypography.callout)
                    .foregroundColor(AppColors.textPrimary)
                    .frame(width: 40, alignment: .leading)
            }
        }
    }
}

struct BestDayCard: View {
    let label: String
    let record: FishingRecord?
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            Text("Best: \(label)")
                .font(AppTypography.caption)
                .foregroundColor(AppColors.textSecondary)
                .lineLimit(1)
            
            if let record = record {
                HStack {
                    Text(formattedDate(record.date))
                        .font(AppTypography.callout)
                        .foregroundColor(AppColors.textPrimary)
                    
                    Spacer()
                    
                    Text("\(record.catchRating)")
                        .font(AppTypography.headline)
                        .foregroundColor(AppColors.excellent)
                }
            } else {
                Text("No data")
                    .font(AppTypography.callout)
                    .foregroundColor(AppColors.textSecondary)
            }
        }
        .padding(AppSpacing.sm)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppColors.surface)
        .cornerRadius(AppCorners.small)
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }
}
