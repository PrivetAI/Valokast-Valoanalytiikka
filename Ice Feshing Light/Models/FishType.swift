import Foundation

struct FishType: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var isCustom: Bool
    
    init(id: UUID = UUID(), name: String, isCustom: Bool = false) {
        self.id = id
        self.name = name
        self.isCustom = isCustom
    }
    
    static let defaultTypes: [FishType] = [
        FishType(name: "Perch"),
        FishType(name: "Pike"),
        FishType(name: "Bream"),
        FishType(name: "Roach"),
        FishType(name: "Crucian"),
        FishType(name: "Zander"),
        FishType(name: "Ruff"),
        FishType(name: "Burbot")
    ]
}
