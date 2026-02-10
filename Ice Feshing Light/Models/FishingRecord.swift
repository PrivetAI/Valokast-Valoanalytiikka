import Foundation

struct FishingRecord: Identifiable, Codable {
    let id: UUID
    var date: Date
    var weather: WeatherCondition
    var timesOfDay: [TimeOfDay]
    var catchRating: Int // 0-10
    var fishTypeIds: [UUID]
    var biteCount: Int
    var caughtCount: Int
    
    init(
        id: UUID = UUID(),
        date: Date = Date(),
        weather: WeatherCondition = .clear,
        timesOfDay: [TimeOfDay] = [],
        catchRating: Int = 5,
        fishTypeIds: [UUID] = [],
        biteCount: Int = 0,
        caughtCount: Int = 0
    ) {
        self.id = id
        self.date = date
        self.weather = weather
        self.timesOfDay = timesOfDay
        self.catchRating = catchRating
        self.fishTypeIds = fishTypeIds
        self.biteCount = biteCount
        self.caughtCount = caughtCount
    }
    
    var ratingCategory: RatingCategory {
        if catchRating >= 8 {
            return .excellent
        } else if catchRating >= 4 {
            return .average
        } else {
            return .poor
        }
    }
    
    enum RatingCategory {
        case excellent
        case average
        case poor
    }
}
