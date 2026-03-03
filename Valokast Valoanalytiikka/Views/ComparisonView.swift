import SwiftUI

// MARK: - Light Journal View

struct LightJournalView: View {
    @ObservedObject var dataService: DataService
    @ObservedObject var settings: SettingsService
    @State private var showingAddEntry = false
    @State private var newEntry = LightJournalEntry()

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20) {
                SectionHeader(title: "Light Journal", icon: AnyView(
                    JournalShape()
                        .stroke(AppTheme.amber, lineWidth: 1.5)
                ))

                // Add entry button
                Button(action: { showingAddEntry.toggle() }) {
                    HStack {
                        Text("+")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("Log Fishing Session")
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(AppTheme.backgroundPrimary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(AppTheme.amber)
                    .cornerRadius(12)
                }

                // Stats summary (if entries exist)
                if !dataService.journalEntries.isEmpty {
                    GlowCardView(glowColor: AppTheme.coolBlue) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Your Light Data")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(AppTheme.warmWhite)

                            HStack {
                                statItem(label: "Sessions", value: "\(dataService.journalEntries.count)")
                                Spacer()
                                let totalCatch = dataService.journalEntries.map(\.catchCount).reduce(0, +)
                                statItem(label: "Total Catch", value: "\(totalCatch)")
                                Spacer()
                                statItem(label: "Avg Lux", value: String(format: "%.0f", dataService.averageLuxForCatches))
                            }

                            let rates = dataService.catchRateByTimeOfDay()
                            if !rates.isEmpty {
                                Text("Catch Rate by Time")
                                    .font(.caption)
                                    .foregroundColor(AppTheme.dimText)
                                    .padding(.top, 4)
                                TimeWindowBarChart(windows: rates.map { ($0.0, $0.1) })
                            }
                        }
                    }
                }

                // Journal entries list
                if dataService.journalEntries.isEmpty {
                    GlowCardView {
                        VStack(spacing: 8) {
                            JournalShape()
                                .stroke(AppTheme.dimText, lineWidth: 1)
                                .frame(width: 40, height: 40)
                            Text("No journal entries yet")
                                .font(.subheadline)
                                .foregroundColor(AppTheme.dimText)
                            Text("Log your fishing sessions with light conditions to build personal data.")
                                .font(.caption)
                                .foregroundColor(AppTheme.dimText)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                    }
                } else {
                    ForEach(dataService.journalEntries) { entry in
                        GlowCardView {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text(formatDate(entry.date))
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(AppTheme.warmWhite)
                                    Spacer()
                                    Text(entry.timeOfDay)
                                        .font(.caption)
                                        .foregroundColor(AppTheme.amber)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 3)
                                        .background(AppTheme.amber.opacity(0.12))
                                        .cornerRadius(6)
                                }

                                HStack(spacing: 16) {
                                    miniStat(label: "Depth", value: "\(Int(entry.depthFishedFeet)) ft")
                                    miniStat(label: "Lux", value: String(format: "%.0f", entry.estimatedLux))
                                    miniStat(label: "Catch", value: "\(entry.catchCount)")
                                    miniStat(label: "Ice", value: "\(Int(entry.iceThicknessInches))\"")
                                }

                                if !entry.speciesCaught.isEmpty {
                                    let names = entry.speciesCaught.compactMap { id in
                                        FishSpecies.allSpecies.first { $0.id == id }?.name
                                    }
                                    Text("Caught: " + names.joined(separator: ", "))
                                        .font(.caption)
                                        .foregroundColor(AppTheme.bodyText)
                                }

                                if !entry.notes.isEmpty {
                                    Text(entry.notes)
                                        .font(.caption)
                                        .foregroundColor(AppTheme.dimText)
                                        .lineLimit(2)
                                }

                                // Delete button
                                HStack {
                                    Spacer()
                                    Button(action: { dataService.deleteEntry(id: entry.id) }) {
                                        Text("Delete")
                                            .font(.caption)
                                            .foregroundColor(Color.red.opacity(0.7))
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 30)
        }
        .sheet(isPresented: $showingAddEntry) {
            addEntrySheet
        }
    }

    private var addEntrySheet: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    DatePicker("Date", selection: $newEntry.date, displayedComponents: .date)
                        .accentColor(AppTheme.amber)

                    GlowSlider(label: "Latitude", value: $newEntry.latitude, range: 25...70, step: 0.5, unit: "N")
                    GlowSlider(label: "Ice Thickness", value: $newEntry.iceThicknessInches, range: 2...48, step: 1, unit: "in", format: "%.0f")
                    GlowSlider(label: "Snow Cover", value: $newEntry.snowCoverInches, range: 0...24, step: 0.5, unit: "in")

                    VStack(alignment: .leading, spacing: 6) {
                        Text("Water Clarity")
                            .font(.subheadline)
                            .foregroundColor(AppTheme.dimText)
                        ClarityPicker(clarity: $newEntry.waterClarity)
                    }

                    GlowSlider(label: "Depth Fished", value: $newEntry.depthFishedFeet, range: 1...100, step: 1, unit: "ft", format: "%.0f")

                    VStack(alignment: .leading, spacing: 6) {
                        Text("Time of Day")
                            .font(.subheadline)
                            .foregroundColor(AppTheme.dimText)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 6) {
                                ForEach(LightJournalEntry.timeOptions, id: \.self) { time in
                                    Button(action: { newEntry.timeOfDay = time }) {
                                        Text(time)
                                            .font(.caption)
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 6)
                                            .foregroundColor(newEntry.timeOfDay == time ? AppTheme.backgroundPrimary : AppTheme.bodyText)
                                            .background(newEntry.timeOfDay == time ? AppTheme.amber : AppTheme.backgroundSecondary)
                                            .cornerRadius(8)
                                    }
                                }
                            }
                        }
                    }

                    // Species selector for targeted
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Species Targeted")
                            .font(.subheadline)
                            .foregroundColor(AppTheme.dimText)
                        SpeciesSelector(selectedID: $newEntry.speciesTargeted, species: FishSpecies.allSpecies)
                    }

                    NumberInputField(label: "Catch Count", value: Binding(
                        get: { Double(newEntry.catchCount) },
                        set: { newEntry.catchCount = Int($0) }
                    ), range: 0...99, step: 1, unit: "fish", format: "%.0f")

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Notes")
                            .font(.subheadline)
                            .foregroundColor(AppTheme.dimText)
                        TextEditor(text: $newEntry.notes)
                            .frame(height: 60)
                            .padding(4)
                            .background(AppTheme.backgroundSecondary)
                            .cornerRadius(8)
                            .foregroundColor(AppTheme.bodyText)
                    }
                }
                .padding(16)
            }
            .background(AppTheme.backgroundPrimary.ignoresSafeArea())
            .navigationBarTitle("Log Session", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") { showingAddEntry = false }
                    .foregroundColor(AppTheme.dimText),
                trailing: Button("Save") {
                    // Calculate estimated lux
                    let cond = IceCondition(iceThicknessInches: newEntry.iceThicknessInches, snowCoverInches: newEntry.snowCoverInches, waterClarity: newEntry.waterClarity)
                    let solar = SolarCalculator(latitude: newEntry.latitude, date: newEntry.date)
                    let hourForTime: Double = {
                        switch newEntry.timeOfDay {
                        case "Dawn": return 6
                        case "Morning": return 9
                        case "Midday": return 12
                        case "Afternoon": return 15
                        case "Dusk": return 18
                        case "Night": return 22
                        default: return 12
                        }
                    }()
                    let surfLux = solar.surfaceLux(atHour: hourForTime)
                    newEntry.estimatedLux = cond.luxAtDepth(surfaceLux: surfLux, depthFeet: newEntry.depthFishedFeet)
                    dataService.addEntry(newEntry)
                    newEntry = LightJournalEntry()
                    showingAddEntry = false
                }
                .foregroundColor(AppTheme.amber)
            )
        }
    }

    private func formatDate(_ date: Date) -> String {
        let df = DateFormatter()
        df.dateFormat = "MMM d, yyyy"
        df.locale = Locale(identifier: "en_US")
        return df.string(from: date)
    }

    private func statItem(label: String, value: String) -> some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.headline)
                .foregroundColor(AppTheme.amber)
            Text(label)
                .font(.caption2)
                .foregroundColor(AppTheme.dimText)
        }
    }

    private func miniStat(label: String, value: String) -> some View {
        VStack(spacing: 1) {
            Text(value)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(AppTheme.warmWhite)
            Text(label)
                .font(.system(size: 9))
                .foregroundColor(AppTheme.dimText)
        }
    }
}
