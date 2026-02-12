import Foundation

// MARK: - Settings Service

class SettingsService: ObservableObject {
    @Published var latitude: Double {
        didSet { UserDefaults.standard.set(latitude, forKey: "user_latitude") }
    }

    @Published var defaultIceThickness: Double {
        didSet { UserDefaults.standard.set(defaultIceThickness, forKey: "default_ice_thickness") }
    }

    @Published var defaultSnowCover: Double {
        didSet { UserDefaults.standard.set(defaultSnowCover, forKey: "default_snow_cover") }
    }

    @Published var defaultWaterClarity: String {
        didSet { UserDefaults.standard.set(defaultWaterClarity, forKey: "default_water_clarity") }
    }

    init() {
        let ud = UserDefaults.standard
        self.latitude = ud.object(forKey: "user_latitude") as? Double ?? 45.0
        self.defaultIceThickness = ud.object(forKey: "default_ice_thickness") as? Double ?? 12.0
        self.defaultSnowCover = ud.object(forKey: "default_snow_cover") as? Double ?? 2.0
        self.defaultWaterClarity = ud.string(forKey: "default_water_clarity") ?? IceCondition.WaterClarity.clear.rawValue
    }

    var defaultCondition: IceCondition {
        IceCondition(
            iceThicknessInches: defaultIceThickness,
            snowCoverInches: defaultSnowCover,
            waterClarity: IceCondition.WaterClarity(rawValue: defaultWaterClarity) ?? .clear
        )
    }
}
