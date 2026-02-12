import Foundation

// MARK: - Data Service for Light Journal

class DataService: ObservableObject {
    @Published var journalEntries: [LightJournalEntry] = []

    private let fileKey = "light_journal_entries"

    init() {
        loadEntries()
    }

    private var fileURL: URL {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return docs.appendingPathComponent("\(fileKey).json")
    }

    func loadEntries() {
        guard let data = try? Data(contentsOf: fileURL),
              let entries = try? JSONDecoder().decode([LightJournalEntry].self, from: data) else {
            journalEntries = []
            return
        }
        journalEntries = entries.sorted { $0.date > $1.date }
    }

    func save() {
        guard let data = try? JSONEncoder().encode(journalEntries) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }

    func addEntry(_ entry: LightJournalEntry) {
        journalEntries.insert(entry, at: 0)
        save()
    }

    func deleteEntry(at offsets: IndexSet) {
        journalEntries.remove(atOffsets: offsets)
        save()
    }

    func deleteEntry(id: UUID) {
        journalEntries.removeAll { $0.id == id }
        save()
    }

    // Analytics helpers
    var averageLuxForCatches: Double {
        let caught = journalEntries.filter { $0.catchCount > 0 }
        guard !caught.isEmpty else { return 0 }
        return caught.map(\.estimatedLux).reduce(0, +) / Double(caught.count)
    }

    func catchRateByTimeOfDay() -> [(String, Double)] {
        let groups = Dictionary(grouping: journalEntries, by: \.timeOfDay)
        return LightJournalEntry.timeOptions.compactMap { time in
            guard let entries = groups[time], !entries.isEmpty else { return nil }
            let caught = entries.filter { $0.catchCount > 0 }.count
            return (time, Double(caught) / Double(entries.count) * 100)
        }
    }
}
