import Foundation

class SettingsService: ObservableObject {
    static let shared = SettingsService()
    
    private let fishTypesKey = "custom_fish_types"
    private let timeBoundariesKey = "time_boundaries"
    
    @Published var fishTypes: [FishType] = []
    @Published var timeBoundaries: TimeBoundaries = TimeBoundaries()
    
    init() {
        loadFishTypes()
        loadTimeBoundaries()
    }
    
    // MARK: - Fish Types
    
    func addFishType(name: String) {
        let newFish = FishType(name: name, isCustom: true)
        fishTypes.append(newFish)
        saveFishTypes()
    }
    
    func removeFishType(_ fish: FishType) {
        guard fish.isCustom else { return }
        fishTypes.removeAll { $0.id == fish.id }
        saveFishTypes()
    }
    
    func getFishName(for id: UUID) -> String {
        fishTypes.first { $0.id == id }?.name ?? "Unknown"
    }
    
    private func loadFishTypes() {
        if let data = UserDefaults.standard.data(forKey: fishTypesKey),
           let saved = try? JSONDecoder().decode([FishType].self, from: data) {
            // Merge default with custom
            var allTypes = FishType.defaultTypes
            let customTypes = saved.filter { $0.isCustom }
            allTypes.append(contentsOf: customTypes)
            fishTypes = allTypes
        } else {
            fishTypes = FishType.defaultTypes
        }
    }
    
    private func saveFishTypes() {
        let customTypes = fishTypes.filter { $0.isCustom }
        if let data = try? JSONEncoder().encode(customTypes) {
            UserDefaults.standard.set(data, forKey: fishTypesKey)
        }
    }
    
    // MARK: - Time Boundaries
    
    func updateTimeBoundaries(_ boundaries: TimeBoundaries) {
        timeBoundaries = boundaries
        saveTimeBoundaries()
    }
    
    private func loadTimeBoundaries() {
        if let data = UserDefaults.standard.data(forKey: timeBoundariesKey),
           let saved = try? JSONDecoder().decode(TimeBoundaries.self, from: data) {
            timeBoundaries = saved
        }
    }
    
    private func saveTimeBoundaries() {
        if let data = try? JSONEncoder().encode(timeBoundaries) {
            UserDefaults.standard.set(data, forKey: timeBoundariesKey)
        }
    }
    
    // MARK: - Reset
    
    func resetAllData() {
        DataService.shared.clearAllData()
        fishTypes = FishType.defaultTypes
        timeBoundaries = TimeBoundaries()
        UserDefaults.standard.removeObject(forKey: fishTypesKey)
        UserDefaults.standard.removeObject(forKey: timeBoundariesKey)
    }
}

struct TimeBoundaries: Codable {
    var morningStart: Int = 6
    var morningEnd: Int = 10
    var dayStart: Int = 10
    var dayEnd: Int = 15
    var eveningStart: Int = 15
    var eveningEnd: Int = 19
    var nightStart: Int = 19
    var nightEnd: Int = 6
}
