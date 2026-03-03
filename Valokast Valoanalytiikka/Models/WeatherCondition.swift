import Foundation

// MARK: - Ice & Surface Conditions

struct IceCondition: Codable, Hashable {
    var iceThicknessInches: Double
    var snowCoverInches: Double
    var waterClarity: WaterClarity

    enum WaterClarity: String, Codable, CaseIterable, Hashable {
        case crystal = "Crystal Clear"
        case clear = "Clear"
        case moderate = "Moderate"
        case stained = "Stained"
        case murky = "Murky"

        var attenuationCoefficient: Double {
            switch self {
            case .crystal: return 0.05
            case .clear: return 0.10
            case .moderate: return 0.20
            case .stained: return 0.35
            case .murky: return 0.55
            }
        }
    }

    static let defaultCondition = IceCondition(
        iceThicknessInches: 12,
        snowCoverInches: 2,
        waterClarity: .clear
    )

    // Ice transmittance: clear ice transmits ~60-80%, snow-covered ice much less
    var iceTransmittance: Double {
        let clearIceTransmit = max(0.01, 0.80 - (iceThicknessInches * 0.01))
        let snowFactor = max(0.01, exp(-0.5 * snowCoverInches))
        return clearIceTransmit * snowFactor
    }

    // Lux at a given depth (feet) given surface lux
    func luxAtDepth(surfaceLux: Double, depthFeet: Double) -> Double {
        let luxBelowIce = surfaceLux * iceTransmittance
        let depthMeters = depthFeet * 0.3048
        let kd = waterClarity.attenuationCoefficient
        return luxBelowIce * exp(-kd * depthMeters)
    }

    // Label for ice type
    var iceTypeLabel: String {
        if snowCoverInches > 6 { return "Heavy Snow Ice" }
        if snowCoverInches > 2 { return "Snow Covered" }
        if snowCoverInches > 0.5 { return "Light Snow" }
        return "Clear Ice"
    }
}
