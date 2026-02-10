import Foundation

enum WeatherCondition: String, Codable, CaseIterable, Identifiable {
    case clear = "clear"
    case cloudy = "cloudy"
    case overcast = "overcast"
    case snowing = "snowing"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .clear: return "Clear"
        case .cloudy: return "Cloudy"
        case .overcast: return "Overcast"
        case .snowing: return "Snowing"
        }
    }
    
    var shortName: String {
        switch self {
        case .clear: return "Clear"
        case .cloudy: return "Cloudy"
        case .overcast: return "Ovrcast"
        case .snowing: return "Snow"
        }
    }
}
