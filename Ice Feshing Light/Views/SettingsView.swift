import SwiftUI

// MARK: - Knowledge Base View

struct KnowledgeBaseView: View {
    @State private var expandedArticle: String? = nil

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 16) {
                SectionHeader(title: "Knowledge Base", icon: AnyView(
                    BookShape()
                        .stroke(AppTheme.amber, lineWidth: 1.5)
                ))

                Text("Understanding how light affects fish behavior under ice.")
                    .font(.caption)
                    .foregroundColor(AppTheme.dimText)
                    .frame(maxWidth: .infinity, alignment: .leading)

                ForEach(KnowledgeArticle.allArticles) { article in
                    GlowCardView(glowColor: expandedArticle == article.id ? AppTheme.amber : AppTheme.backgroundCard) {
                        VStack(alignment: .leading, spacing: 0) {
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.25)) {
                                    expandedArticle = expandedArticle == article.id ? nil : article.id
                                }
                            }) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(article.title)
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                            .foregroundColor(AppTheme.warmWhite)
                                            .multilineTextAlignment(.leading)
                                        Text(article.subtitle)
                                            .font(.caption)
                                            .foregroundColor(AppTheme.dimText)
                                    }
                                    Spacer()
                                    Path { path in
                                        let w: CGFloat = 10
                                        let h: CGFloat = 6
                                        if expandedArticle == article.id {
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
                                }
                            }
                            .buttonStyle(PlainButtonStyle())

                            if expandedArticle == article.id {
                                Divider()
                                    .background(AppTheme.amber.opacity(0.3))
                                    .padding(.vertical, 10)

                                Text(article.body)
                                    .font(.caption)
                                    .foregroundColor(AppTheme.bodyText)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .lineSpacing(4)
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

// MARK: - Knowledge Articles Data

struct KnowledgeArticle: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let body: String

    static let allArticles: [KnowledgeArticle] = [
        KnowledgeArticle(
            id: "snow_cover",
            title: "How Snow Cover Affects Fishing",
            subtitle: "The single biggest factor in under-ice light",
            body: """
            Snow cover is the most significant factor affecting light penetration through ice. Even a thin layer of snow (1-2 inches) can reduce light transmission by 50-80%, while heavy snow cover (6+ inches) blocks virtually all sunlight from reaching the water below.

            Clear ice without snow can transmit 60-80% of surface light, creating conditions similar to open water for fish. This means sight-feeding species like perch and pike remain active throughout the day under clear ice.

            When snow accumulates, the underwater world shifts dramatically. Light-sensitive species like walleye and sauger gain an advantage as their superior low-light vision allows them to hunt effectively while their prey struggles to see. This is why many experienced ice anglers actually prefer fishing after a fresh snowfall when targeting walleye.

            The type of snow matters too. Fresh, fluffy snow reflects more light and blocks penetration more effectively than compacted, wet snow. As snow ages and compresses, it may actually allow slightly more light through, especially if it partially melts and refreezes into a more translucent layer.

            Practical tip: If you find an area where wind has blown snow off the ice, creating a clear patch, fish the edges where light transitions to shadow. Predators often patrol these light boundaries.
            """
        ),
        KnowledgeArticle(
            id: "walleye_dusk",
            title: "Why Walleye Bite at Dusk",
            subtitle: "The science behind the golden hour",
            body: """
            Walleye are legendary for their dusk and dawn feeding activity, and the reason lies in their unique eye structure. Walleye possess a reflective layer behind their retina called the tapetum lucidum, similar to what makes cat eyes glow in the dark. This gives them exceptional vision in low-light conditions.

            During the transition periods of dawn and dusk, light levels drop to a range (roughly 5-80 lux at depth) where walleye can see clearly but most of their prey species cannot. This creates a significant predatory advantage that walleye exploit aggressively.

            Under ice, this effect is amplified. The ice and any snow cover further reduce light levels, which means the "walleye advantage zone" may extend further into daylight hours. On heavily snow-covered ice, walleye may feed actively even at midday because light levels at depth are already in their preferred range.

            The key insight for ice anglers: rather than focusing solely on time of day, focus on the actual light level at your target depth. A bright midday under clear ice might produce poor walleye fishing, while the same time under heavy snow cover could be excellent.

            Monitor conditions and adjust your timing accordingly. Use ice thickness and snow cover measurements to estimate when light levels at your fishing depth will enter the walleye comfort zone.
            """
        ),
        KnowledgeArticle(
            id: "clear_vs_snow",
            title: "Clear Ice vs Snow Ice",
            subtitle: "How ice formation affects light transmission",
            body: """
            Not all ice is created equal when it comes to light transmission. The way ice forms determines its optical properties, and understanding this can help you predict underwater light conditions.

            Clear (black) ice forms when water freezes slowly in calm conditions. This ice is nearly transparent and can transmit 60-80% of incident light. Lakes that freeze during calm, cold nights often develop excellent clear ice. Fish beneath clear ice experience something close to open-water light conditions.

            Snow ice (white ice) forms when snow on the surface partially melts and refreezes, or when water seeps up through cracks and freezes with trapped snow. This ice is opaque and milky white, transmitting only 10-30% of light even without additional snow cover.

            Layered ice is common on many lakes: a base layer of clear ice topped with one or more layers of snow ice formed during thaw-freeze cycles. Light transmission through layered ice is complex and generally poor.

            Slush pockets between ice layers scatter light dramatically, reducing penetration even further. These pockets form when the weight of snow pushes ice below the water line, allowing water to seep up and saturate the snow layer.

            Practical application: Early season ice is typically clearer and allows more light. As winter progresses, snow accumulation and thaw-freeze cycles degrade ice clarity. Plan your species targets accordingly: early season may favor sight feeders, while late season under degraded ice favors low-light specialists.
            """
        ),
        KnowledgeArticle(
            id: "moonlight",
            title: "Moonlight Night Fishing",
            subtitle: "Fishing under ice after dark",
            body: """
            Night fishing through the ice is an underutilized tactic that can produce exceptional results, particularly for species like burbot, walleye, and large pike. Moonlight plays a crucial role in night fishing success.

            A full moon on a clear night can produce 0.1-0.3 lux at the ice surface. While this seems negligible, through clear ice with no snow cover, enough light reaches the upper water column to enable some visual feeding. This is sufficient for species with excellent night vision like walleye and burbot.

            Burbot are primarily nocturnal feeders and are most active in near-total darkness. They are one of the few freshwater fish that spawn under ice (typically January-March), and their activity peaks during the darkest nights. Moonless nights under heavy snow cover create ideal burbot conditions.

            Walleye feeding during bright moonlit nights tends to be shallower than during dark nights. The additional moonlight allows them to hunt effectively at shallower depths where they might normally avoid during brighter periods.

            New moon phases, especially under snow-covered ice, create the darkest possible conditions and tend to concentrate nocturnal feeders in shallower water where even minimal light provides an advantage.

            For night ice fishing, consider that your headlamp and lantern also affect local light conditions. Some anglers intentionally fish in the dark (no lights) when targeting light-sensitive species, using glow-in-the-dark lures instead.
            """
        ),
        KnowledgeArticle(
            id: "artificial_light",
            title: "Artificial Light Attractors",
            subtitle: "Using lights to attract fish under ice",
            body: """
            Submersible fishing lights have become increasingly popular for ice fishing. These lights work by creating a localized zone of illumination that attracts plankton, which in turn attracts baitfish, which then draws predators.

            Green light (wavelength around 520nm) penetrates water most effectively and is the most popular color for submersible fishing lights. It travels further through water than other colors and is highly attractive to zooplankton.

            The light creates a distinct gradient from bright (near the source) to dark (further away). Different species position themselves at different distances from the light based on their light preference. Crappie and perch often move into the illuminated zone, while walleye typically patrol the shadows at the edge of the light cone.

            Light intensity matters. A light that is too bright can actually push light-sensitive species further away. Many experienced anglers use dimmable lights or position their lights at a depth where the intensity at the fishing zone matches their target species preference.

            Timing considerations: artificial lights are most effective during low-light periods (dusk, night, dawn) and under heavy snow cover when natural light is minimal. During bright midday conditions under clear ice, adding artificial light has less impact because ambient light levels are already relatively high.

            Green glow sticks and UV-reactive lures use a different principle, making lures more visible rather than attracting the food chain. These work well for species that feed by sight in low-light conditions.
            """
        ),
        KnowledgeArticle(
            id: "uv_lures",
            title: "UV Light and Lure Selection",
            subtitle: "Why UV-enhanced lures outperform in certain conditions",
            body: """
            Ultraviolet light penetrates water differently than visible light, and many fish species can see into the UV spectrum. This has significant implications for lure selection when ice fishing.

            UV light penetrates clear water effectively but is scattered and absorbed quickly in stained or murky water. Under clear ice with minimal snow, UV levels beneath the ice can be surprisingly high, especially during midday.

            Many fish species, including trout, perch, and pike, have UV-sensitive photoreceptors. Research shows that juvenile fish and zooplankton are often highly UV-reflective, meaning predators may use UV vision to locate prey. Lures that fluoresce or reflect UV light can appear more natural and visible to these species.

            In low-light conditions (deep water, heavy snow cover, dusk/dawn), UV fluorescent lures that convert invisible UV radiation into visible light can make a lure appear to glow, increasing visibility even when overall light levels are low.

            Color selection should match light conditions: in bright, clear conditions with high UV, use natural UV-reflective patterns. In dim conditions, use high-contrast fluorescent colors (chartreuse, orange, pink) that maximize visibility. In very low light, glow-in-the-dark lures charged with a flashlight are often most effective.

            Water clarity is key: in crystal clear water, subtle UV enhancement works best. In stained water, bold fluorescent colors cut through the reduced visibility. Match your lure brightness to the light level fish are experiencing at your target depth.
            """
        ),
        KnowledgeArticle(
            id: "penetration_science",
            title: "Light Penetration Science",
            subtitle: "The physics of light under frozen lakes",
            body: """
            Understanding how light behaves as it passes through ice and water is fundamental to predicting fish behavior in winter. The process involves reflection, absorption, and scattering at each layer.

            At the snow surface, fresh snow reflects 80-95% of incoming light. This is the biggest single barrier to light penetration. Compacted or wet snow reflects less (50-70%), and ice alone reflects only 5-15%.

            Light attenuation in water follows Beer-Lambert Law: intensity decreases exponentially with depth. The attenuation coefficient depends on water clarity, measured by dissolved and suspended particles. Crystal clear water (Kd = 0.05/m) allows significant light to reach 30+ meters. Murky water (Kd = 0.55/m) may reduce light to near-zero within 5 meters.

            The euphotic zone, where enough light exists for photosynthesis (roughly 1% of surface light), determines the productive depth of a lake in winter. Below this zone, the water is functionally dark regardless of surface conditions.

            Different wavelengths penetrate to different depths. Red light is absorbed within the first few meters. Blue and green light penetrate deepest. This is why deep water appears blue-green and why green fishing lights are most effective at depth.

            Under ice, the light spectrum shifts compared to open water. Ice and snow preferentially filter certain wavelengths, and the light reaching deep water under ice has a different spectral composition than in summer. Fish adapted to winter feeding may rely on different visual cues than during open water seasons.

            Temperature affects light transmission too. Colder water is slightly more transparent than warm water, and winter lakes often have better clarity than summer due to reduced biological activity. This partially compensates for the ice and snow barrier above.
            """
        ),
        KnowledgeArticle(
            id: "seasonal_changes",
            title: "Seasonal Light Changes",
            subtitle: "How light evolves through the ice fishing season",
            body: """
            The ice fishing season spans several months, and light conditions change dramatically from early ice to late ice. Understanding these changes helps you adapt your strategies throughout winter.

            Early ice (November-December in northern latitudes) typically features thin, clear ice with minimal snow. Day length is decreasing rapidly toward the winter solstice. Despite short days, the clear ice allows good light penetration during daylight hours. Sight-feeding species like perch and pike are often very active during this period.

            Mid-winter (January-February) brings the coldest temperatures, thickest ice, and often the most snow accumulation. Days are short but lengthening slowly after the solstice. The combination of thick ice, snow cover, and short days creates the darkest conditions of the year. This is prime time for low-light specialists: walleye, sauger, and burbot.

            Late ice (March-April) brings rapidly increasing day length, stronger sun angle, and melting snow. The higher sun angle means more light energy per unit area, and melting snow reveals clearer ice. Light levels beneath the ice can increase dramatically in spring. This triggers increased biological activity, including plankton blooms that can actually reduce water clarity even as surface light increases.

            Sun angle matters greatly. In December at 45 degrees N latitude, the noon sun is only about 21 degrees above the horizon. By March, it reaches 45 degrees. Higher sun angles mean more light passes through the ice surface rather than being reflected, and the light penetrates more directly into the water column.

            Plan your species targets around these seasonal light patterns. Target aggressive sight-feeders during the clear-ice periods of early and late season, and focus on low-light species during the dark mid-winter months.
            """
        )
    ]
}
