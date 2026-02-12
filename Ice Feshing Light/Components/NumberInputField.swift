import SwiftUI

// MARK: - Number Input Field

struct NumberInputField: View {
    let label: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    let step: Double
    let unit: String
    var format: String = "%.1f"

    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundColor(AppTheme.dimText)
            Spacer()
            Button(action: { if value - step >= range.lowerBound { value -= step } }) {
                Text("-")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(AppTheme.amber)
                    .frame(width: 32, height: 32)
                    .background(AppTheme.backgroundSecondary)
                    .cornerRadius(8)
            }
            Text(String(format: format, value) + " " + unit)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(AppTheme.warmWhite)
                .frame(minWidth: 60)
            Button(action: { if value + step <= range.upperBound { value += step } }) {
                Text("+")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(AppTheme.amber)
                    .frame(width: 32, height: 32)
                    .background(AppTheme.backgroundSecondary)
                    .cornerRadius(8)
            }
        }
    }
}
