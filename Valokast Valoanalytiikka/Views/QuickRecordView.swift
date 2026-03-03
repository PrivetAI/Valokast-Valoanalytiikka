import SwiftUI

// MARK: - Light Dashboard View (main screen)

struct LightDashboardView: View {
    @ObservedObject var settings: SettingsService
    @State private var iceThickness: Double = 12
    @State private var snowCover: Double = 2
    @State private var waterClarity: IceCondition.WaterClarity = .clear
    @State private var targetDepth: Double = 15

    private var condition: IceCondition {
        IceCondition(iceThicknessInches: iceThickness, snowCoverInches: snowCover, waterClarity: waterClarity)
    }

    private var solar: SolarCalculator {
        SolarCalculator(latitude: settings.latitude, date: Date())
    }

    private var currentHour: Double {
        let cal = Calendar.current
        return Double(cal.component(.hour, from: Date())) + Double(cal.component(.minute, from: Date())) / 60.0
    }

    private var surfaceLux: Double {
        solar.surfaceLux(atHour: currentHour)
    }

    private var luxAtTarget: Double {
        condition.luxAtDepth(surfaceLux: surfaceLux, depthFeet: targetDepth)
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20) {
                // Header with light rays
                ZStack {
                    LightRaysView(rayCount: 16, color: AppTheme.amber)
                        .frame(height: 140)
                        .clipped()

                    VStack(spacing: 8) {
                        SunShape()
                            .stroke(AppTheme.amber, lineWidth: 2)
                            .frame(width: 40, height: 40)

                        Text("Current Light Conditions")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(AppTheme.warmWhite)

                        Text(timeLabel)
                            .font(.caption)
                            .foregroundColor(AppTheme.dimText)
                    }
                    .padding(.top, 20)
                }

                // Current light readings
                GlowCardView {
                    VStack(spacing: 16) {
                        HStack(spacing: 20) {
                            LuxGauge(currentLux: surfaceLux, maxLux: 100000, label: "Surface")
                                .frame(width: 90, height: 100)
                            LuxGauge(currentLux: surfaceLux * condition.iceTransmittance, maxLux: 100000, label: "Below Ice")
                                .frame(width: 90, height: 100)
                            LuxGauge(currentLux: luxAtTarget, maxLux: 100000, label: "\(Int(targetDepth)) ft Depth")
                                .frame(width: 90, height: 100)
                        }

                        // Ice cross section mini
                        IceCrossSectionView(iceThickness: iceThickness, snowCover: snowCover)
                            .frame(height: 100)
                            .cornerRadius(8)
                    }
                }

                // Condition sliders
                GlowCardView(glowColor: AppTheme.iceBlue) {
                    VStack(spacing: 14) {
                        SectionHeader(title: "Ice Conditions", icon: AnyView(
                            IceCrystalShape()
                                .stroke(AppTheme.iceBlue, lineWidth: 1.5)
                        ))

                        GlowSlider(label: "Ice Thickness", value: $iceThickness, range: 2...48, step: 1, unit: "in", format: "%.0f")
                        GlowSlider(label: "Snow Cover", value: $snowCover, range: 0...24, step: 0.5, unit: "in")
                        ClarityPicker(clarity: $waterClarity)
                        GlowSlider(label: "Target Depth", value: $targetDepth, range: 1...100, step: 1, unit: "ft", format: "%.0f")

                        HStack {
                            Text("Transmittance:")
                                .font(.caption)
                                .foregroundColor(AppTheme.dimText)
                            Spacer()
                            Text(String(format: "%.1f%%", condition.iceTransmittance * 100))
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(AppTheme.amber)
                        }
                    }
                }

                // Quick species match
                GlowCardView(glowColor: AppTheme.amber) {
                    VStack(alignment: .leading, spacing: 10) {
                        SectionHeader(title: "Species at This Light", icon: AnyView(
                            FishShape()
                                .fill(AppTheme.amber)
                        ))

                        let matchedSpecies = FishSpecies.allSpecies.filter {
                            luxAtTarget >= $0.preferredLuxMin && luxAtTarget <= $0.preferredLuxMax
                        }

                        if matchedSpecies.isEmpty {
                            Text("No species prefer this light level (\(String(format: "%.0f", luxAtTarget)) lux). Adjust depth or conditions.")
                                .font(.caption)
                                .foregroundColor(AppTheme.dimText)
                        } else {
                            ForEach(matchedSpecies) { sp in
                                HStack {
                                    FishShape()
                                        .fill(AppTheme.amber)
                                        .frame(width: 20, height: 14)
                                    Text(sp.name)
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(AppTheme.warmWhite)
                                    Spacer()
                                    Text(sp.lightCategory)
                                        .font(.caption2)
                                        .foregroundColor(AppTheme.amber)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 3)
                                        .background(AppTheme.amber.opacity(0.12))
                                        .cornerRadius(6)
                                }
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 30)
        }
    }

    private var timeLabel: String {
        let df = DateFormatter()
        df.dateFormat = "EEEE, MMM d - h:mm a"
        df.locale = Locale(identifier: "en_US")
        return df.string(from: Date())
    }
}
