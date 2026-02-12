import SwiftUI

// MARK: - Depth Light Chart View

struct DepthChartView: View {
    @ObservedObject var settings: SettingsService
    @State private var iceThickness: Double = 12
    @State private var snowCover: Double = 2
    @State private var waterClarity: IceCondition.WaterClarity = .clear
    @State private var maxDepth: Double = 60
    @State private var selectedSpeciesID: String = "walleye"

    private var condition: IceCondition {
        IceCondition(iceThicknessInches: iceThickness, snowCoverInches: snowCover, waterClarity: waterClarity)
    }

    private var solar: SolarCalculator {
        SolarCalculator(latitude: settings.latitude, date: Date())
    }

    private var currentSurfaceLux: Double {
        let cal = Calendar.current
        let h = Double(cal.component(.hour, from: Date())) + Double(cal.component(.minute, from: Date())) / 60.0
        return solar.surfaceLux(atHour: h)
    }

    private var selectedSpecies: FishSpecies? {
        FishSpecies.allSpecies.first { $0.id == selectedSpeciesID }
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20) {
                SectionHeader(title: "Depth Light Chart", icon: AnyView(
                    DepthArrowShape()
                        .stroke(AppTheme.coolBlue, lineWidth: 1.5)
                ))

                // The main depth-light graph
                GlowCardView(glowColor: AppTheme.coolBlue) {
                    VStack(spacing: 12) {
                        DepthLightGraph(
                            condition: condition,
                            surfaceLux: currentSurfaceLux,
                            maxDepthFeet: maxDepth,
                            highlightDepth: selectedSpecies?.optimalDepthMinFt,
                            speciesRange: selectedSpecies.map { (min: $0.preferredLuxMin, max: $0.preferredLuxMax) }
                        )
                        .frame(height: 280)

                        // Legend
                        HStack(spacing: 16) {
                            legendItem(color: AppTheme.amber, text: "Light curve")
                            if selectedSpecies != nil {
                                legendItem(color: AppTheme.amber.opacity(0.3), text: "Preferred zone")
                            }
                        }
                    }
                }

                // Species selector
                GlowCardView {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Select Species Overlay")
                            .font(.subheadline)
                            .foregroundColor(AppTheme.dimText)
                        SpeciesSelector(selectedID: $selectedSpeciesID, species: FishSpecies.allSpecies)

                        if let sp = selectedSpecies {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("\(sp.name): \(String(format: "%.0f", sp.preferredLuxMin))-\(String(format: "%.0f", sp.preferredLuxMax)) lux")
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .foregroundColor(AppTheme.amber)
                                Text("Optimal depth: \(String(format: "%.0f", sp.optimalDepthMinFt))-\(String(format: "%.0f", sp.optimalDepthMaxFt)) ft")
                                    .font(.caption)
                                    .foregroundColor(AppTheme.bodyText)
                            }
                        }
                    }
                }

                // Condition controls
                GlowCardView(glowColor: AppTheme.iceBlue) {
                    VStack(spacing: 12) {
                        Text("Adjust Conditions")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(AppTheme.warmWhite)
                        GlowSlider(label: "Ice Thickness", value: $iceThickness, range: 2...48, step: 1, unit: "in", format: "%.0f")
                        GlowSlider(label: "Snow Cover", value: $snowCover, range: 0...24, step: 0.5, unit: "in")
                        ClarityPicker(clarity: $waterClarity)
                        GlowSlider(label: "Max Depth", value: $maxDepth, range: 10...150, step: 5, unit: "ft", format: "%.0f")
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 30)
        }
    }

    private func legendItem(color: Color, text: String) -> some View {
        HStack(spacing: 4) {
            Circle().fill(color).frame(width: 8, height: 8)
            Text(text).font(.caption2).foregroundColor(AppTheme.dimText)
        }
    }
}
