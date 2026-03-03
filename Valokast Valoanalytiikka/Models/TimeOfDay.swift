import Foundation

// MARK: - Solar & Light Calculator

struct SolarCalculator {
    let latitude: Double
    let date: Date

    // Approximate solar elevation angle at a given hour (0-24)
    func solarElevation(atHour hour: Double) -> Double {
        let calendar = Calendar.current
        let dayOfYear = Double(calendar.ordinality(of: .day, in: .year, for: date) ?? 1)

        let declination = 23.45 * sin(toRadians(360.0 / 365.0 * (dayOfYear - 81)))
        let latRad = toRadians(latitude)
        let declRad = toRadians(declination)

        let hourAngle = (hour - 12.0) * 15.0
        let hourAngleRad = toRadians(hourAngle)

        let sinElev = sin(latRad) * sin(declRad) + cos(latRad) * cos(declRad) * cos(hourAngleRad)
        return toDegrees(asin(max(-1, min(1, sinElev))))
    }

    // Surface lux estimate based on solar elevation
    func surfaceLux(atHour hour: Double) -> Double {
        let elev = solarElevation(atHour: hour)
        if elev < -6 { return 1 } // Night
        if elev < 0 { return 10 + (elev + 6) * 50 } // Civil twilight
        if elev < 10 { return 300 + elev * 500 } // Low sun
        if elev < 30 { return 5300 + (elev - 10) * 1000 } // Mid
        return min(100000, 25300 + (elev - 30) * 800) // High sun
    }

    // Generate hourly light profile for the day
    func hourlyProfile() -> [(hour: Int, surfaceLux: Double)] {
        (0...23).map { h in
            (hour: h, surfaceLux: surfaceLux(atHour: Double(h)))
        }
    }

    // Find sunrise/sunset approximate hours
    var sunriseHour: Double {
        for h in stride(from: 0.0, through: 12.0, by: 0.25) {
            if solarElevation(atHour: h) > 0 { return h }
        }
        return 7
    }

    var sunsetHour: Double {
        for h in stride(from: 23.75, through: 12.0, by: -0.25) {
            if solarElevation(atHour: h) > 0 { return h }
        }
        return 17
    }

    var daylightHours: Double {
        return max(0, sunsetHour - sunriseHour)
    }

    private func toRadians(_ degrees: Double) -> Double { degrees * .pi / 180 }
    private func toDegrees(_ radians: Double) -> Double { radians * 180 / .pi }
}
