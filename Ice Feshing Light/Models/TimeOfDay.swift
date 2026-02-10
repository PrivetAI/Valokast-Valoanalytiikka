import Foundation

enum TimeOfDay: String, Codable, CaseIterable, Identifiable {
    case morning = "morning"
    case day = "day"
    case evening = "evening"
    case night = "night"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .morning: return "Morning"
        case .day: return "Day"
        case .evening: return "Evening"
        case .night: return "Night"
        }
    }
    
    var timeRange: String {
        switch self {
        case .morning: return "6-10"
        case .day: return "10-15"
        case .evening: return "15-19"
        case .night: return "19-6"
        }
    }
    
    var defaultStartHour: Int {
        switch self {
        case .morning: return 6
        case .day: return 10
        case .evening: return 15
        case .night: return 19
        }
    }
    
    var defaultEndHour: Int {
        switch self {
        case .morning: return 10
        case .day: return 15
        case .evening: return 19
        case .night: return 6
        }
    }
}
