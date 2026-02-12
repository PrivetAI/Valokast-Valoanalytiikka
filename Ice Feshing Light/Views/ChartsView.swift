import SwiftUI

// MARK: - Best Times Calculator View

struct BestTimesView: View {
    @ObservedObject var settings: SettingsService
    @State private var latitude: Double = 45
    @State private var selectedDate = Date()
    @State private var iceThickness: Double = 12
    @State private var snowCover: Double = 2
    @State private var waterClarity: IceCondition.WaterClarity = .clear
    @State private var targetDepth: Double = 15
    @State private var selectedSpeciesID: String = "walleye"

    private var condition: IceCondition {
        IceCondition(iceThicknessInches: iceThickness, snowCoverInches: snowCover, waterClarity: waterClarity)
    }

    private var solar: SolarCalculator {
        SolarCalculator(latitude: latitude, date: selectedDate)
    }

    private var selectedSpecies: FishSpecies? {
        FishSpecies.allSpecies.first { $0.id == selectedSpeciesID }
    }

    // Compute best windows: hours where lux at target depth matches species preference
    private var hourlyScores: [(label: String, score: Double)] {
        guard let sp = selectedSpecies else { return [] }
        let windows = [
            ("5-7 AM", 5.0, 7.0),
            ("7-9 AM", 7.0, 9.0),
            ("9-11 AM", 9.0, 11.0),
            ("11-1 PM", 11.0, 13.0),
            ("1-3 PM", 13.0, 15.0),
            ("3-5 PM", 15.0, 17.0),
            ("5-7 PM", 17.0, 19.0),
            ("7-9 PM", 19.0, 21.0),
        ]

        return windows.map { (label, startH, endH) in
            var totalScore = 0.0
            var samples = 0
            var h = startH
            while h < endH {
                let surfLux = solar.surfaceLux(atHour: h)
                let depthLux = condition.luxAtDepth(surfaceLux: surfLux, depthFeet: targetDepth)
                // Score: how well does depth lux match species preference?
                let midPref = (sp.preferredLuxMin + sp.preferredLuxMax) / 2
                let range = max(1, sp.preferredLuxMax - sp.preferredLuxMin)
                let distance = abs(depthLux - midPref)
                let score = max(0, 1 - distance / (range * 2)) * 100
                totalScore += score
                samples += 1
                h += 0.5
            }
            return (label, samples > 0 ? totalScore / Double(samples) : 0)
        }
    }

    private var bestHours: [Int] {
        guard let sp = selectedSpecies else { return [] }
        var hours: [Int] = []
        for h in 0...23 {
            let surfLux = solar.surfaceLux(atHour: Double(h))
            let depthLux = condition.luxAtDepth(surfaceLux: surfLux, depthFeet: targetDepth)
            if depthLux >= sp.preferredLuxMin && depthLux <= sp.preferredLuxMax {
                hours.append(h)
            }
        }
        return hours
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20) {
                SectionHeader(title: "Best Times Calculator", icon: AnyView(
                    ClockShape()
                        .stroke(AppTheme.amber, lineWidth: 1.5)
                ))

                // Species selector
                GlowCardView {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Target Species")
                            .font(.subheadline)
                            .foregroundColor(AppTheme.dimText)
                        SpeciesSelector(selectedID: $selectedSpeciesID, species: FishSpecies.allSpecies)
                    }
                }

                // Inputs
                GlowCardView(glowColor: AppTheme.iceBlue) {
                    VStack(spacing: 12) {
                        GlowSlider(label: "Latitude", value: $latitude, range: 25...70, step: 0.5, unit: "N")
                        DatePicker("Date", selection: $selectedDate, displayedComponents: .date)
                            .datePickerStyle(CompactDatePickerStyle())
                            .foregroundColor(AppTheme.bodyText)
                            .accentColor(AppTheme.amber)
                        GlowSlider(label: "Ice Thickness", value: $iceThickness, range: 2...48, step: 1, unit: "in", format: "%.0f")
                        GlowSlider(label: "Snow Cover", value: $snowCover, range: 0...24, step: 0.5, unit: "in")
                        ClarityPicker(clarity: $waterClarity)
                        GlowSlider(label: "Target Depth", value: $targetDepth, range: 1...100, step: 1, unit: "ft", format: "%.0f")
                    }
                }

                // Hourly light chart with best hours highlighted
                GlowCardView(glowColor: AppTheme.amber) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Light at \(Int(targetDepth)) ft Throughout Day")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(AppTheme.warmWhite)

                        let hourlyData = solar.hourlyProfile().map { (hour: $0.hour, lux: condition.luxAtDepth(surfaceLux: $0.surfaceLux, depthFeet: targetDepth)) }
                        let maxLux = hourlyData.map(\.lux).max() ?? 1

                        HourlyLightChart(
                            dataPoints: hourlyData,
                            maxLux: maxLux,
                            highlightHours: bestHours
                        )
                        .frame(height: 180)
                    }
                }

                // Time windows scored
                GlowCardView {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Fishing Window Scores")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(AppTheme.warmWhite)

                        if let sp = selectedSpecies {
                            Text("Based on \(sp.name) light preference (\(String(format: "%.0f", sp.preferredLuxMin))-\(String(format: "%.0f", sp.preferredLuxMax)) lux)")
                                .font(.caption)
                                .foregroundColor(AppTheme.dimText)
                        }

                        TimeWindowBarChart(windows: hourlyScores)
                    }
                }

                // Daylight summary
                GlowCardView(glowColor: AppTheme.coolBlue) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Sunrise")
                                .font(.caption)
                                .foregroundColor(AppTheme.dimText)
                            Text(formatHour(solar.sunriseHour))
                                .font(.headline)
                                .foregroundColor(AppTheme.amberGlow)
                        }
                        Spacer()
                        VStack(spacing: 4) {
                            Text("Daylight")
                                .font(.caption)
                                .foregroundColor(AppTheme.dimText)
                            Text(String(format: "%.1f hrs", solar.daylightHours))
                                .font(.headline)
                                .foregroundColor(AppTheme.warmWhite)
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("Sunset")
                                .font(.caption)
                                .foregroundColor(AppTheme.dimText)
                            Text(formatHour(solar.sunsetHour))
                                .font(.headline)
                                .foregroundColor(AppTheme.lowLight)
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 30)
        }
        .onAppear { latitude = settings.latitude }
    }

    private func formatHour(_ h: Double) -> String {
        let hr = Int(h)
        let min = Int((h - Double(hr)) * 60)
        let ampm = hr >= 12 ? "PM" : "AM"
        let h12 = hr > 12 ? hr - 12 : (hr == 0 ? 12 : hr)
        return String(format: "%d:%02d %@", h12, min, ampm)
    }
}
