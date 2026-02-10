import SwiftUI

struct LineChart: View {
    let dataPoints: [(date: Date, value: Double, weather: WeatherCondition)]
    var lineColor: Color = AppColors.primary
    var showWeatherIcons: Bool = true
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            let maxValue: Double = 10
            let minValue: Double = 0
            
            ZStack {
                // Grid lines
                VStack(spacing: 0) {
                    ForEach(0..<5) { i in
                        Divider()
                            .background(AppColors.surface)
                        if i < 4 {
                            Spacer()
                        }
                    }
                }
                .padding(.bottom, showWeatherIcons ? 30 : 0)
                
                // Y-axis labels
                VStack {
                    Text("10")
                    Spacer()
                    Text("5")
                    Spacer()
                    Text("0")
                }
                .font(AppTypography.caption)
                .foregroundColor(AppColors.textSecondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, showWeatherIcons ? 30 : 0)
                
                if !dataPoints.isEmpty {
                    // Line and fill
                    let points = calculatePoints(width: width - 30, height: height - (showWeatherIcons ? 50 : 20), maxValue: maxValue, minValue: minValue)
                    
                    // Fill gradient
                    Path { path in
                        guard points.count > 1 else { return }
                        path.move(to: CGPoint(x: points[0].x + 30, y: height - (showWeatherIcons ? 50 : 20)))
                        path.addLine(to: CGPoint(x: points[0].x + 30, y: points[0].y))
                        
                        for point in points.dropFirst() {
                            path.addLine(to: CGPoint(x: point.x + 30, y: point.y))
                        }
                        
                        path.addLine(to: CGPoint(x: points.last!.x + 30, y: height - (showWeatherIcons ? 50 : 20)))
                        path.closeSubpath()
                    }
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [lineColor.opacity(0.3), lineColor.opacity(0.05)]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    
                    // Line
                    Path { path in
                        guard points.count > 1 else { return }
                        path.move(to: CGPoint(x: points[0].x + 30, y: points[0].y))
                        
                        for point in points.dropFirst() {
                            path.addLine(to: CGPoint(x: point.x + 30, y: point.y))
                        }
                    }
                    .stroke(lineColor, style: StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
                    
                    // Data points and weather icons
                    ForEach(Array(zip(points.indices, points)), id: \.0) { index, point in
                        VStack(spacing: 2) {
                            Circle()
                                .fill(lineColor)
                                .frame(width: 8, height: 8)
                            
                            if showWeatherIcons && index < dataPoints.count {
                                WeatherIcon(condition: dataPoints[index].weather, size: 16)
                            }
                        }
                        .position(x: point.x + 30, y: point.y + (showWeatherIcons ? 12 : 0))
                    }
                }
            }
        }
        .frame(height: 200)
    }
    
    private func calculatePoints(width: CGFloat, height: CGFloat, maxValue: Double, minValue: Double) -> [CGPoint] {
        guard dataPoints.count > 1 else {
            if let first = dataPoints.first {
                let y = height - CGFloat((first.value - minValue) / (maxValue - minValue)) * height
                return [CGPoint(x: width / 2, y: y)]
            }
            return []
        }
        
        let stepX = width / CGFloat(dataPoints.count - 1)
        
        return dataPoints.enumerated().map { index, point in
            let x = CGFloat(index) * stepX
            let y = height - CGFloat((point.value - minValue) / (maxValue - minValue)) * height
            return CGPoint(x: x, y: y)
        }
    }
}
