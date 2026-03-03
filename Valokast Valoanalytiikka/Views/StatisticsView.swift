import SwiftUI

// MARK: - Species Light Preferences View

struct SpeciesLightView: View {
    @State private var expandedID: String? = nil

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 16) {
                SectionHeader(title: "Species Light Preferences", icon: AnyView(
                    FishShape()
                        .fill(AppTheme.amber)
                ))

                Text("How light intensity affects fish behavior and feeding under ice.")
                    .font(.caption)
                    .foregroundColor(AppTheme.dimText)
                    .frame(maxWidth: .infinity, alignment: .leading)

                ForEach(FishSpecies.allSpecies) { sp in
                    GlowCardView(glowColor: expandedID == sp.id ? AppTheme.amber : AppTheme.backgroundCard) {
                        VStack(alignment: .leading, spacing: 0) {
                            // Header row (always visible)
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.25)) {
                                    expandedID = expandedID == sp.id ? nil : sp.id
                                }
                            }) {
                                HStack {
                                    FishShape()
                                        .fill(AppTheme.amber)
                                        .frame(width: 24, height: 16)

                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(sp.name)
                                            .font(.headline)
                                            .foregroundColor(AppTheme.warmWhite)
                                        Text(sp.lightCategory)
                                            .font(.caption2)
                                            .foregroundColor(AppTheme.amber)
                                    }

                                    Spacer()

                                    // Light range indicator
                                    VStack(alignment: .trailing, spacing: 2) {
                                        Text("\(String(format: "%.0f", sp.preferredLuxMin))-\(String(format: "%.0f", sp.preferredLuxMax))")
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .foregroundColor(AppTheme.amber)
                                        Text("lux range")
                                            .font(.system(size: 9))
                                            .foregroundColor(AppTheme.dimText)
                                    }

                                    // Expand chevron
                                    Path { path in
                                        let w: CGFloat = 10
                                        let h: CGFloat = 6
                                        if expandedID == sp.id {
                                            path.move(to: CGPoint(x: 0, y: h))
                                            path.addLine(to: CGPoint(x: w / 2, y: 0))
                                            path.addLine(to: CGPoint(x: w, y: h))
                                        } else {
                                            path.move(to: CGPoint(x: 0, y: 0))
                                            path.addLine(to: CGPoint(x: w / 2, y: h))
                                            path.addLine(to: CGPoint(x: w, y: 0))
                                        }
                                    }
                                    .stroke(AppTheme.dimText, lineWidth: 1.5)
                                    .frame(width: 10, height: 6)
                                    .padding(.leading, 6)
                                }
                            }
                            .buttonStyle(PlainButtonStyle())

                            // Expanded detail
                            if expandedID == sp.id {
                                VStack(alignment: .leading, spacing: 12) {
                                    Divider().background(AppTheme.amber.opacity(0.3))

                                    // Light range bar
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Preferred Light Range")
                                            .font(.caption)
                                            .fontWeight(.medium)
                                            .foregroundColor(AppTheme.dimText)

                                        GeometryReader { geo in
                                            let totalW = geo.size.width
                                            let logMin = log10(max(1, sp.preferredLuxMin)) / 5.0
                                            let logMax = log10(max(1, sp.preferredLuxMax)) / 5.0
                                            ZStack(alignment: .leading) {
                                                Capsule().fill(AppTheme.backgroundSecondary).frame(height: 10)
                                                Capsule()
                                                    .fill(AppTheme.amber.opacity(0.6))
                                                    .frame(width: totalW * CGFloat(logMax - logMin), height: 10)
                                                    .offset(x: totalW * CGFloat(logMin))
                                            }
                                        }
                                        .frame(height: 10)

                                        HStack {
                                            Text("0 lux")
                                                .font(.system(size: 8))
                                                .foregroundColor(AppTheme.dimText)
                                            Spacer()
                                            Text("100k lux")
                                                .font(.system(size: 8))
                                                .foregroundColor(AppTheme.dimText)
                                        }
                                    }

                                    // Depth range
                                    HStack {
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text("Optimal Depth")
                                                .font(.caption)
                                                .foregroundColor(AppTheme.dimText)
                                            Text("\(String(format: "%.0f", sp.optimalDepthMinFt)) - \(String(format: "%.0f", sp.optimalDepthMaxFt)) ft")
                                                .font(.subheadline)
                                                .fontWeight(.bold)
                                                .foregroundColor(AppTheme.coolBlue)
                                        }
                                        Spacer()
                                    }

                                    // Feeding note
                                    Text(sp.feedingLightNote)
                                        .font(.caption)
                                        .foregroundColor(AppTheme.bodyText)
                                        .fixedSize(horizontal: false, vertical: true)

                                    // Full description
                                    Text(sp.description)
                                        .font(.caption)
                                        .foregroundColor(AppTheme.dimText)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                                .padding(.top, 10)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 30)
        }
    }
}
