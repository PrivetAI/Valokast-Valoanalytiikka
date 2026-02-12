import SwiftUI

// MARK: - Species Selector

struct SpeciesSelector: View {
    @Binding var selectedID: String
    let species: [FishSpecies]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(species) { sp in
                    Button(action: { selectedID = sp.id }) {
                        VStack(spacing: 4) {
                            FishShape()
                                .fill(selectedID == sp.id ? AppTheme.amber : AppTheme.dimText)
                                .frame(width: 28, height: 18)
                            Text(sp.name)
                                .font(.caption2)
                                .fontWeight(selectedID == sp.id ? .bold : .regular)
                                .foregroundColor(selectedID == sp.id ? AppTheme.amber : AppTheme.bodyText)
                                .lineLimit(1)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 8)
                        .background(selectedID == sp.id ? AppTheme.amber.opacity(0.12) : AppTheme.backgroundSecondary)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(selectedID == sp.id ? AppTheme.amber.opacity(0.5) : Color.clear, lineWidth: 1)
                        )
                    }
                }
            }
            .padding(.horizontal, 4)
        }
    }
}
