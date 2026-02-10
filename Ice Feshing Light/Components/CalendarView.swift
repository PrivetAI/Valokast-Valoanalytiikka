import SwiftUI

struct CalendarView: View {
    @Binding var selectedDate: Date
    let records: [FishingRecord]
    let onDateTap: (Date) -> Void
    
    @State private var currentMonth: Date = Date()
    
    private let calendar = Calendar.current
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 7)
    private let weekdays = ["S", "M", "T", "W", "T", "F", "S"]
    
    var body: some View {
        VStack(spacing: AppSpacing.md) {
            // Month navigation
            HStack {
                Button(action: previousMonth) {
                    BackIcon(size: 24, color: AppColors.primary)
                }
                
                Spacer()
                
                Text(monthYearString)
                    .font(AppTypography.headline)
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
                
                Button(action: nextMonth) {
                    BackIcon(size: 24, color: AppColors.primary)
                        .rotationEffect(.degrees(180))
                }
            }
            .padding(.horizontal, AppSpacing.sm)
            
            // Weekday headers
            LazyVGrid(columns: columns, spacing: 4) {
                ForEach(weekdays, id: \.self) { day in
                    Text(day)
                        .font(AppTypography.caption)
                        .foregroundColor(AppColors.textSecondary)
                        .frame(height: 24)
                }
            }
            
            // Days grid
            LazyVGrid(columns: columns, spacing: 4) {
                ForEach(daysInMonth, id: \.self) { date in
                    if let date = date {
                        DayCell(
                            date: date,
                            record: getRecord(for: date),
                            isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                            isToday: calendar.isDateInToday(date)
                        ) {
                            selectedDate = date
                            onDateTap(date)
                        }
                    } else {
                        Color.clear
                            .frame(height: 52)
                    }
                }
            }
        }
        .padding(AppSpacing.md)
        .background(AppColors.cardBackground)
        .cornerRadius(AppCorners.large)
    }
    
    private var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: currentMonth)
    }
    
    private var daysInMonth: [Date?] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentMonth),
              let monthFirstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start) else {
            return []
        }
        
        var days: [Date?] = []
        let firstDayOfMonth = monthInterval.start
        let startOfFirstWeek = monthFirstWeek.start
        
        // Add empty cells for days before month starts
        var currentDate = startOfFirstWeek
        while currentDate < firstDayOfMonth {
            days.append(nil)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        }
        
        // Add days of month
        currentDate = firstDayOfMonth
        while currentDate < monthInterval.end {
            days.append(currentDate)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        }
        
        // Fill remaining cells in last week
        while days.count % 7 != 0 {
            days.append(nil)
        }
        
        return days
    }
    
    private func getRecord(for date: Date) -> FishingRecord? {
        records.first { calendar.isDate($0.date, inSameDayAs: date) }
    }
    
    private func previousMonth() {
        currentMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
    }
    
    private func nextMonth() {
        currentMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
    }
}

struct DayCell: View {
    let date: Date
    let record: FishingRecord?
    let isSelected: Bool
    let isToday: Bool
    let action: () -> Void
    
    private let calendar = Calendar.current
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 2) {
                Text("\(calendar.component(.day, from: date))")
                    .font(AppTypography.callout)
                    .foregroundColor(textColor)
                
                if let record = record {
                    WeatherIcon(condition: record.weather, size: 16)
                } else {
                    Color.clear.frame(height: 16)
                }
            }
            .frame(height: 52)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: AppCorners.small)
                    .fill(backgroundColor)
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppCorners.small)
                    .stroke(isSelected ? AppColors.primary : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var backgroundColor: Color {
        guard let record = record else {
            return isToday ? AppColors.surface : Color.clear
        }
        
        switch record.ratingCategory {
        case .excellent:
            return AppColors.excellent.opacity(0.3)
        case .average:
            return AppColors.average.opacity(0.3)
        case .poor:
            return AppColors.poor.opacity(0.3)
        }
    }
    
    private var textColor: Color {
        if isSelected {
            return AppColors.primary
        } else if record != nil {
            return AppColors.textPrimary
        } else if isToday {
            return AppColors.primary
        } else {
            return AppColors.textSecondary
        }
    }
}
