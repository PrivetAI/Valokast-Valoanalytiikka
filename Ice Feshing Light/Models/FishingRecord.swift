import Foundation

// MARK: - Light Journal Entry

struct LightJournalEntry: Identifiable, Codable {
    var id: UUID
    var date: Date
    var latitude: Double
    var iceThicknessInches: Double
    var snowCoverInches: Double
    var waterClarity: IceCondition.WaterClarity
    var depthFishedFeet: Double
    var speciesTargeted: String
    var speciesCaught: [String]
    var catchCount: Int
    var estimatedLux: Double
    var timeOfDay: String // "Dawn", "Morning", "Midday", "Afternoon", "Dusk", "Night"
    var notes: String

    init(
        id: UUID = UUID(),
        date: Date = Date(),
        latitude: Double = 45.0,
        iceThicknessInches: Double = 12,
        snowCoverInches: Double = 2,
        waterClarity: IceCondition.WaterClarity = .clear,
        depthFishedFeet: Double = 15,
        speciesTargeted: String = "walleye",
        speciesCaught: [String] = [],
        catchCount: Int = 0,
        estimatedLux: Double = 0,
        timeOfDay: String = "Morning",
        notes: String = ""
    ) {
        self.id = id
        self.date = date
        self.latitude = latitude
        self.iceThicknessInches = iceThicknessInches
        self.snowCoverInches = snowCoverInches
        self.waterClarity = waterClarity
        self.depthFishedFeet = depthFishedFeet
        self.speciesTargeted = speciesTargeted
        self.speciesCaught = speciesCaught
        self.catchCount = catchCount
        self.estimatedLux = estimatedLux
        self.timeOfDay = timeOfDay
        self.notes = notes
    }

    static let timeOptions = ["Dawn", "Morning", "Midday", "Afternoon", "Dusk", "Night"]
}
