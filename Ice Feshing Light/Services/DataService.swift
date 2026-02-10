import Foundation

class DataService: ObservableObject {
    static let shared = DataService()
    
    private let recordsKey = "fishing_records"
    
    @Published var records: [FishingRecord] = []
    
    init() {
        loadRecords()
    }
    
    // MARK: - CRUD Operations
    
    func saveRecord(_ record: FishingRecord) {
        if let index = records.firstIndex(where: { $0.id == record.id }) {
            records[index] = record
        } else {
            records.append(record)
        }
        persistRecords()
    }
    
    func deleteRecord(_ record: FishingRecord) {
        records.removeAll { $0.id == record.id }
        persistRecords()
    }
    
    func deleteRecord(at offsets: IndexSet) {
        records.remove(atOffsets: offsets)
        persistRecords()
    }
    
    func getRecord(for date: Date) -> FishingRecord? {
        let calendar = Calendar.current
        return records.first { calendar.isDate($0.date, inSameDayAs: date) }
    }
    
    func getRecords(for month: Date) -> [FishingRecord] {
        let calendar = Calendar.current
        return records.filter {
            calendar.isDate($0.date, equalTo: month, toGranularity: .month)
        }
    }
    
    func getLast30DaysRecords() -> [FishingRecord] {
        let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date()
        return records.filter { $0.date >= thirtyDaysAgo }.sorted { $0.date < $1.date }
    }
    
    // MARK: - Statistics
    
    func getWeatherStats() -> [WeatherCondition: WeatherStats] {
        var stats: [WeatherCondition: WeatherStats] = [:]
        
        for weather in WeatherCondition.allCases {
            let weatherRecords = records.filter { $0.weather == weather }
            if !weatherRecords.isEmpty {
                let totalDays = weatherRecords.count
                let avgRating = Double(weatherRecords.map { $0.catchRating }.reduce(0, +)) / Double(totalDays)
                let excellentDays = weatherRecords.filter { $0.catchRating >= 8 }.count
                let successRate = Double(excellentDays) / Double(totalDays) * 100
                
                stats[weather] = WeatherStats(
                    daysCount: totalDays,
                    averageRating: avgRating,
                    successRate: successRate
                )
            }
        }
        
        return stats
    }
    
    func getTimeStats() -> [TimeOfDay: TimeStats] {
        var stats: [TimeOfDay: TimeStats] = [:]
        
        for time in TimeOfDay.allCases {
            let timeRecords = records.filter { $0.timesOfDay.contains(time) }
            if !timeRecords.isEmpty {
                let totalDays = timeRecords.count
                let avgRating = Double(timeRecords.map { $0.catchRating }.reduce(0, +)) / Double(totalDays)
                let excellentDays = timeRecords.filter { $0.catchRating >= 8 }.count
                let successRate = Double(excellentDays) / Double(totalDays) * 100
                
                stats[time] = TimeStats(
                    daysCount: totalDays,
                    averageRating: avgRating,
                    successRate: successRate
                )
            }
        }
        
        return stats
    }
    
    func getFishStats(fishTypes: [FishType]) -> [UUID: FishStats] {
        var stats: [UUID: FishStats] = [:]
        
        for fish in fishTypes {
            let fishRecords = records.filter { $0.fishTypeIds.contains(fish.id) }
            if !fishRecords.isEmpty {
                let totalDays = fishRecords.count
                let avgRating = Double(fishRecords.map { $0.catchRating }.reduce(0, +)) / Double(totalDays)
                
                // Best weather
                var weatherCounts: [WeatherCondition: (count: Int, totalRating: Int)] = [:]
                for record in fishRecords {
                    let current = weatherCounts[record.weather] ?? (0, 0)
                    weatherCounts[record.weather] = (current.count + 1, current.totalRating + record.catchRating)
                }
                let bestWeather = weatherCounts.max { a, b in
                    Double(a.value.totalRating) / Double(a.value.count) < Double(b.value.totalRating) / Double(b.value.count)
                }?.key
                
                // Best time
                var timeCounts: [TimeOfDay: (count: Int, totalRating: Int)] = [:]
                for record in fishRecords {
                    for time in record.timesOfDay {
                        let current = timeCounts[time] ?? (0, 0)
                        timeCounts[time] = (current.count + 1, current.totalRating + record.catchRating)
                    }
                }
                let bestTime = timeCounts.max { a, b in
                    Double(a.value.totalRating) / Double(a.value.count) < Double(b.value.totalRating) / Double(b.value.count)
                }?.key
                
                stats[fish.id] = FishStats(
                    daysCount: totalDays,
                    averageRating: avgRating,
                    bestWeather: bestWeather,
                    bestTime: bestTime
                )
            }
        }
        
        return stats
    }
    
    func getOverallStats() -> OverallStats {
        let totalDays = records.count
        let totalBites = records.map { $0.biteCount }.reduce(0, +)
        let totalCaught = records.map { $0.caughtCount }.reduce(0, +)
        let bestDay = records.max { $0.catchRating < $1.catchRating }
        let avgRating = totalDays > 0 ? Double(records.map { $0.catchRating }.reduce(0, +)) / Double(totalDays) : 0
        
        return OverallStats(
            totalDays: totalDays,
            totalBites: totalBites,
            totalCaught: totalCaught,
            bestDay: bestDay,
            averageRating: avgRating
        )
    }
    
    func getRecommendations(fishTypes: [FishType]) -> [String] {
        var recommendations: [String] = []
        
        let weatherStats = getWeatherStats()
        let timeStats = getTimeStats()
        let fishStats = getFishStats(fishTypes: fishTypes)
        
        // Best weather + time combo
        if let bestWeather = weatherStats.max(by: { $0.value.averageRating < $1.value.averageRating }),
           let bestTime = timeStats.max(by: { $0.value.averageRating < $1.value.averageRating }) {
            recommendations.append(
                "Your best catch is during \(bestWeather.key.displayName.lowercased()) weather in the \(bestTime.key.displayName.lowercased()) (avg \(String(format: "%.1f", bestWeather.value.averageRating)))"
            )
        }
        
        // Best fish conditions
        for (fishId, stat) in fishStats {
            if let fish = fishTypes.first(where: { $0.id == fishId }),
               let weather = stat.bestWeather,
               let time = stat.bestTime {
                recommendations.append(
                    "\(fish.name) bites best during \(weather.displayName.lowercased()) \(time.displayName.lowercased())"
                )
            }
        }
        
        // Worst weather warning
        if let worstWeather = weatherStats.min(by: { $0.value.averageRating < $1.value.averageRating }),
           worstWeather.value.averageRating < 4 {
            recommendations.append(
                "During \(worstWeather.key.displayName.lowercased()) weather, catch is consistently low - consider staying home"
            )
        }
        
        return recommendations
    }
    
    func getConditionStats(weather: WeatherCondition, time: TimeOfDay) -> ConditionStats {
        let matchingRecords = records.filter { $0.weather == weather && $0.timesOfDay.contains(time) }
        let count = matchingRecords.count
        let avgRating = count > 0 ? Double(matchingRecords.map { $0.catchRating }.reduce(0, +)) / Double(count) : 0
        let bestDay = matchingRecords.max { $0.catchRating < $1.catchRating }
        
        return ConditionStats(
            timesInCondition: count,
            averageRating: avgRating,
            bestDay: bestDay
        )
    }
    
    // MARK: - Persistence
    
    private func loadRecords() {
        guard let data = UserDefaults.standard.data(forKey: recordsKey) else { return }
        do {
            records = try JSONDecoder().decode([FishingRecord].self, from: data)
        } catch {
            print("Failed to load records: \(error)")
        }
    }
    
    private func persistRecords() {
        do {
            let data = try JSONEncoder().encode(records)
            UserDefaults.standard.set(data, forKey: recordsKey)
        } catch {
            print("Failed to save records: \(error)")
        }
    }
    
    func clearAllData() {
        records = []
        UserDefaults.standard.removeObject(forKey: recordsKey)
    }
}

// MARK: - Stats Models

struct WeatherStats {
    let daysCount: Int
    let averageRating: Double
    let successRate: Double
}

struct TimeStats {
    let daysCount: Int
    let averageRating: Double
    let successRate: Double
}

struct FishStats {
    let daysCount: Int
    let averageRating: Double
    let bestWeather: WeatherCondition?
    let bestTime: TimeOfDay?
}

struct OverallStats {
    let totalDays: Int
    let totalBites: Int
    let totalCaught: Int
    let bestDay: FishingRecord?
    let averageRating: Double
}

struct ConditionStats {
    let timesInCondition: Int
    let averageRating: Double
    let bestDay: FishingRecord?
}
