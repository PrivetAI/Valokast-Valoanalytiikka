import Foundation

// MARK: - Fish Species with Light Preferences

struct FishSpecies: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let preferredLuxMin: Double
    let preferredLuxMax: Double
    let optimalDepthMinFt: Double
    let optimalDepthMaxFt: Double
    let feedingLightNote: String
    let description: String

    var lightCategory: String {
        if preferredLuxMax <= 100 { return "Low Light" }
        if preferredLuxMin >= 2000 { return "High Light" }
        return "Moderate Light"
    }

    static let allSpecies: [FishSpecies] = [
        FishSpecies(
            id: "walleye", name: "Walleye",
            preferredLuxMin: 5, preferredLuxMax: 80,
            optimalDepthMinFt: 15, optimalDepthMaxFt: 35,
            feedingLightNote: "Most active at dawn/dusk when light is dim. Excellent low-light vision gives them advantage over prey.",
            description: "Walleye have a reflective tapetum lucidum layer behind their retinas, giving them superior vision in low-light conditions. They actively avoid bright light and move deeper or into shade during midday."
        ),
        FishSpecies(
            id: "perch", name: "Yellow Perch",
            preferredLuxMin: 200, preferredLuxMax: 5000,
            optimalDepthMinFt: 8, optimalDepthMaxFt: 25,
            feedingLightNote: "Feed actively in moderate light. Daytime feeder that uses vision to find food.",
            description: "Perch are sight-feeders that rely on decent light levels to identify prey. They are most active during daylight hours under clear or thin ice."
        ),
        FishSpecies(
            id: "pike", name: "Northern Pike",
            preferredLuxMin: 1000, preferredLuxMax: 15000,
            optimalDepthMinFt: 4, optimalDepthMaxFt: 15,
            feedingLightNote: "Ambush predator active in well-lit shallow water. Uses vision to track prey movement.",
            description: "Pike are aggressive visual hunters that prefer clear, well-lit water. They often lurk in shallow weedy areas where light penetrates well through ice."
        ),
        FishSpecies(
            id: "laketrout", name: "Lake Trout",
            preferredLuxMin: 20, preferredLuxMax: 500,
            optimalDepthMinFt: 30, optimalDepthMaxFt: 80,
            feedingLightNote: "Deep dweller comfortable in dim conditions. Feeds across a range of light levels.",
            description: "Lake trout inhabit deep, cold water where light is naturally reduced. They are adapted to feeding in dim conditions and may come shallower during low-light periods."
        ),
        FishSpecies(
            id: "crappie", name: "Crappie",
            preferredLuxMin: 50, preferredLuxMax: 800,
            optimalDepthMinFt: 10, optimalDepthMaxFt: 25,
            feedingLightNote: "Active in low to moderate light. Dawn and dusk are prime feeding times.",
            description: "Crappie have large eyes adapted for low-light feeding. They often suspend at mid-depths where light intensity matches their visual comfort zone."
        ),
        FishSpecies(
            id: "bluegill", name: "Bluegill",
            preferredLuxMin: 500, preferredLuxMax: 8000,
            optimalDepthMinFt: 5, optimalDepthMaxFt: 18,
            feedingLightNote: "Daytime sight feeder. Most active when light levels are moderate to bright.",
            description: "Bluegill are small panfish that feed by sight in moderate to well-lit water. They tend to be in shallower zones where light penetration is adequate."
        ),
        FishSpecies(
            id: "burbot", name: "Burbot",
            preferredLuxMin: 0, preferredLuxMax: 30,
            optimalDepthMinFt: 20, optimalDepthMaxFt: 60,
            feedingLightNote: "Nocturnal feeder. Most active in near-darkness, including under heavy snow cover.",
            description: "Burbot are primarily nocturnal and are one of the few freshwater fish that spawn under ice in winter. They actively feed in near-total darkness."
        ),
        FishSpecies(
            id: "whitefish", name: "Whitefish",
            preferredLuxMin: 100, preferredLuxMax: 2000,
            optimalDepthMinFt: 15, optimalDepthMaxFt: 40,
            feedingLightNote: "Feed in moderate light at various depths. Sensitive to bright surface light.",
            description: "Whitefish feed on invertebrates and small organisms, relying on moderate light to spot food. They avoid very bright light and retreat to deeper water when surface illumination is strong."
        ),
        FishSpecies(
            id: "sauger", name: "Sauger",
            preferredLuxMin: 2, preferredLuxMax: 50,
            optimalDepthMinFt: 18, optimalDepthMaxFt: 40,
            feedingLightNote: "Even more light-sensitive than walleye. Peak feeding in very low light or darkness.",
            description: "Sauger have extremely light-sensitive eyes and prefer even dimmer conditions than their walleye cousins. They thrive in murky, deep water with minimal light penetration."
        ),
        FishSpecies(
            id: "rainbow", name: "Rainbow Trout",
            preferredLuxMin: 300, preferredLuxMax: 6000,
            optimalDepthMinFt: 8, optimalDepthMaxFt: 25,
            feedingLightNote: "Active visual feeder in moderate to bright conditions. Good mid-day target.",
            description: "Rainbow trout are active feeders that use their keen eyesight to spot insects and small fish. They are comfortable in well-lit conditions and feed throughout the day."
        ),
        FishSpecies(
            id: "muskie", name: "Muskellunge",
            preferredLuxMin: 800, preferredLuxMax: 12000,
            optimalDepthMinFt: 5, optimalDepthMaxFt: 20,
            feedingLightNote: "Visual ambush predator. Needs good visibility to track large prey.",
            description: "Muskellunge are apex predators that rely on excellent vision to ambush prey. They prefer clear water with good light penetration and are most active during bright conditions."
        ),
        FishSpecies(
            id: "cisco", name: "Cisco (Tullibee)",
            preferredLuxMin: 30, preferredLuxMax: 400,
            optimalDepthMinFt: 20, optimalDepthMaxFt: 50,
            feedingLightNote: "Pelagic feeder in dim to moderate light. Often found at thermocline depth.",
            description: "Cisco are open-water fish that suspend at depths where light levels are moderate. They feed on plankton and small invertebrates, using subtle light cues to find food."
        )
    ]
}
