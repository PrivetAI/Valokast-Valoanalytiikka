import SwiftUI

// MARK: - Main Content View (vertical scrolling with card navigation)

struct ContentView: View {
    @StateObject private var dataService = DataService()
    @StateObject private var settings = SettingsService()
    @State private var selectedSection: AppSection? = nil

    enum AppSection: String, CaseIterable, Identifiable {
        case dashboard = "Light Dashboard"
        case depthChart = "Depth Light Chart"
        case species = "Species Light Preferences"
        case bestTimes = "Best Times Calculator"
        case journal = "Light Journal"
        case knowledge = "Knowledge Base"
        case settings = "Settings"

        var id: String { rawValue }
    }

    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.backgroundPrimary.ignoresSafeArea()

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 20) {
                        // App header
                        VStack(spacing: 8) {
                            ZStack {
                                LightRaysView(rayCount: 20, color: AppTheme.amber)
                                    .frame(height: 100)
                                    .clipped()

                                VStack(spacing: 6) {
                                    SunShape()
                                        .stroke(AppTheme.amber, lineWidth: 2.5)
                                        .frame(width: 36, height: 36)
                                    Text("Valokast: Valoanalytiikka")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(AppTheme.warmWhite)
                                    Text("Light & Visibility Conditions Guide")
                                        .font(.caption)
                                        .foregroundColor(AppTheme.amber)
                                }
                            }
                        }

                        // Navigation cards
                        navCard(
                            section: .dashboard,
                            icon: AnyView(SunShape().stroke(AppTheme.amber, lineWidth: 1.5)),
                            subtitle: "Current light conditions at any depth",
                            color: AppTheme.amber
                        )

                        navCard(
                            section: .depthChart,
                            icon: AnyView(DepthArrowShape().stroke(AppTheme.coolBlue, lineWidth: 1.5)),
                            subtitle: "Visualize light attenuation through ice and water",
                            color: AppTheme.coolBlue
                        )

                        navCard(
                            section: .species,
                            icon: AnyView(FishShape().fill(AppTheme.amber)),
                            subtitle: "12 species with light preferences and feeding data",
                            color: AppTheme.amber
                        )

                        navCard(
                            section: .bestTimes,
                            icon: AnyView(ClockShape().stroke(AppTheme.amberGlow, lineWidth: 1.5)),
                            subtitle: "Calculate optimal fishing windows by light",
                            color: AppTheme.amberGlow
                        )

                        navCard(
                            section: .journal,
                            icon: AnyView(JournalShape().stroke(AppTheme.amber, lineWidth: 1.5)),
                            subtitle: "Log sessions and track your light data",
                            color: AppTheme.amber
                        )

                        navCard(
                            section: .knowledge,
                            icon: AnyView(BookShape().stroke(AppTheme.warmWhite, lineWidth: 1.5)),
                            subtitle: "8 articles on light, ice, and fish behavior",
                            color: AppTheme.warmWhite
                        )

                        navCard(
                            section: .settings,
                            icon: AnyView(GearShape().stroke(AppTheme.dimText, lineWidth: 1.5)),
                            subtitle: "Default location and conditions",
                            color: AppTheme.dimText
                        )
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 40)
                }

                // Hidden NavigationLinks
                ForEach(AppSection.allCases) { section in
                    NavigationLink(
                        destination: destinationView(for: section),
                        tag: section,
                        selection: $selectedSection,
                        label: { EmptyView() }
                    )
                    .hidden()
                }
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    private func navCard(section: AppSection, icon: AnyView, subtitle: String, color: Color) -> some View {
        Button(action: { selectedSection = section }) {
            GlowCardView(glowColor: color) {
                HStack(spacing: 14) {
                    icon.frame(width: 28, height: 28)
                    VStack(alignment: .leading, spacing: 3) {
                        Text(section.rawValue)
                            .font(.headline)
                            .foregroundColor(AppTheme.warmWhite)
                        Text(subtitle)
                            .font(.caption)
                            .foregroundColor(AppTheme.dimText)
                            .lineLimit(2)
                    }
                    Spacer()
                    // Arrow
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: 0))
                        path.addLine(to: CGPoint(x: 8, y: 6))
                        path.addLine(to: CGPoint(x: 0, y: 12))
                    }
                    .stroke(color.opacity(0.5), lineWidth: 1.5)
                    .frame(width: 8, height: 12)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }

    @ViewBuilder
    private func destinationView(for section: AppSection) -> some View {
        Group {
            switch section {
            case .dashboard:
                LightDashboardView(settings: settings)
            case .depthChart:
                DepthChartView(settings: settings)
            case .species:
                SpeciesLightView()
            case .bestTimes:
                BestTimesView(settings: settings)
            case .journal:
                LightJournalView(dataService: dataService, settings: settings)
            case .knowledge:
                KnowledgeBaseView()
            case .settings:
                AppSettingsView(settings: settings)
            }
        }
        .background(AppTheme.backgroundPrimary.ignoresSafeArea())
        .navigationBarTitle(section.rawValue, displayMode: .inline)
    }
}

// MARK: - App Settings View

struct AppSettingsView: View {
    @ObservedObject var settings: SettingsService
    @State private var showPrivacyPolicy = false

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20) {
                SectionHeader(title: "Settings", icon: AnyView(
                    GearShape().stroke(AppTheme.dimText, lineWidth: 1.5)
                ))

                GlowCardView {
                    VStack(spacing: 14) {
                        Text("Default Location")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(AppTheme.warmWhite)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        GlowSlider(label: "Latitude", value: $settings.latitude, range: 25...70, step: 0.5, unit: "N")
                    }
                }

                GlowCardView(glowColor: AppTheme.iceBlue) {
                    VStack(spacing: 14) {
                        Text("Default Ice Conditions")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(AppTheme.warmWhite)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        GlowSlider(label: "Ice Thickness", value: $settings.defaultIceThickness, range: 2...48, step: 1, unit: "in", format: "%.0f")
                        GlowSlider(label: "Snow Cover", value: $settings.defaultSnowCover, range: 0...24, step: 0.5, unit: "in")
                    }
                }

                GlowCardView {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("About")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(AppTheme.warmWhite)
                        Text("Valokast: Valoanalytiikka is a tool for understanding how light penetration, visibility, and ice conditions affect fish behavior and feeding activity under frozen lakes.")
                            .font(.caption)
                            .foregroundColor(AppTheme.dimText)
                            .fixedSize(horizontal: false, vertical: true)
                        Text("Version 1.0")
                            .font(.caption2)
                            .foregroundColor(AppTheme.dimText)
                    }
                }

                GlowCardView {
                    Button(action: { showPrivacyPolicy = true }) {
                        HStack {
                            Text("Privacy Policy")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(AppTheme.warmWhite)
                            Spacer()
                            Path { path in
                                path.move(to: CGPoint(x: 0, y: 0))
                                path.addLine(to: CGPoint(x: 8, y: 6))
                                path.addLine(to: CGPoint(x: 0, y: 12))
                            }
                            .stroke(AppTheme.dimText, lineWidth: 1.5)
                            .frame(width: 8, height: 12)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 30)
        }
        .sheet(isPresented: $showPrivacyPolicy) {
            ValokastWebPanel(urlString: "https://www.freeprivacypolicy.com/live/70b82691-253a-4723-8fb6-a7d774c29b17")
                .edgesIgnoringSafeArea(.all)
        }
    }
}
