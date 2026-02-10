import SwiftUI

// MARK: - Sun Icon (Clear Weather)
struct SunIcon: View {
    var size: CGFloat = 24
    var color: Color = AppColors.sunny
    
    var body: some View {
        ZStack {
            // Rays
            ForEach(0..<8) { i in
                RoundedRectangle(cornerRadius: 1)
                    .fill(color)
                    .frame(width: size * 0.08, height: size * 0.2)
                    .offset(y: -size * 0.35)
                    .rotationEffect(.degrees(Double(i) * 45))
            }
            
            // Center circle
            Circle()
                .fill(color)
                .frame(width: size * 0.5, height: size * 0.5)
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Cloud Shape
struct CloudShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        
        // Main cloud body using circles
        path.addEllipse(in: CGRect(x: w * 0.1, y: h * 0.4, width: w * 0.35, height: h * 0.5))
        path.addEllipse(in: CGRect(x: w * 0.3, y: h * 0.2, width: w * 0.4, height: h * 0.55))
        path.addEllipse(in: CGRect(x: w * 0.55, y: h * 0.35, width: w * 0.35, height: h * 0.5))
        
        return path
    }
}

// MARK: - Cloudy Icon (Partial Clouds)
struct CloudyIcon: View {
    var size: CGFloat = 24
    var sunColor: Color = AppColors.sunny
    var cloudColor: Color = AppColors.cloudy
    
    var body: some View {
        ZStack {
            // Sun behind
            SunIcon(size: size * 0.6, color: sunColor)
                .offset(x: size * 0.15, y: -size * 0.15)
            
            // Cloud in front
            CloudShape()
                .fill(cloudColor)
                .frame(width: size * 0.8, height: size * 0.5)
                .offset(x: -size * 0.05, y: size * 0.15)
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Overcast Icon (Full Clouds)
struct OvercastIcon: View {
    var size: CGFloat = 24
    var color: Color = AppColors.overcast
    
    var body: some View {
        ZStack {
            // Back cloud
            CloudShape()
                .fill(color.opacity(0.6))
                .frame(width: size * 0.7, height: size * 0.45)
                .offset(x: size * 0.1, y: -size * 0.1)
            
            // Front cloud
            CloudShape()
                .fill(color)
                .frame(width: size * 0.85, height: size * 0.55)
                .offset(y: size * 0.1)
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Snowflake Shape
struct SnowflakeShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        
        for i in 0..<6 {
            let angle = Double(i) * 60 * .pi / 180
            let endX = center.x + radius * CGFloat(cos(angle))
            let endY = center.y + radius * CGFloat(sin(angle))
            
            path.move(to: center)
            path.addLine(to: CGPoint(x: endX, y: endY))
            
            // Small branches
            let branchStart = CGPoint(
                x: center.x + radius * 0.6 * CGFloat(cos(angle)),
                y: center.y + radius * 0.6 * CGFloat(sin(angle))
            )
            
            let branchAngle1 = angle + 0.5
            let branchAngle2 = angle - 0.5
            
            path.move(to: branchStart)
            path.addLine(to: CGPoint(
                x: branchStart.x + radius * 0.25 * CGFloat(cos(branchAngle1)),
                y: branchStart.y + radius * 0.25 * CGFloat(sin(branchAngle1))
            ))
            
            path.move(to: branchStart)
            path.addLine(to: CGPoint(
                x: branchStart.x + radius * 0.25 * CGFloat(cos(branchAngle2)),
                y: branchStart.y + radius * 0.25 * CGFloat(sin(branchAngle2))
            ))
        }
        
        return path
    }
}

// MARK: - Snowing Icon
struct SnowingIcon: View {
    var size: CGFloat = 24
    var cloudColor: Color = AppColors.snowing
    var snowColor: Color = Color.white
    
    var body: some View {
        ZStack {
            // Cloud
            CloudShape()
                .fill(cloudColor)
                .frame(width: size * 0.85, height: size * 0.45)
                .offset(y: -size * 0.15)
            
            // Snowflakes
            HStack(spacing: size * 0.15) {
                SnowflakeShape()
                    .stroke(snowColor, lineWidth: 1.2)
                    .frame(width: size * 0.2, height: size * 0.2)
                
                SnowflakeShape()
                    .stroke(snowColor, lineWidth: 1.2)
                    .frame(width: size * 0.15, height: size * 0.15)
                    .offset(y: size * 0.08)
                
                SnowflakeShape()
                    .stroke(snowColor, lineWidth: 1.2)
                    .frame(width: size * 0.2, height: size * 0.2)
            }
            .offset(y: size * 0.25)
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Weather Icon View
struct WeatherIcon: View {
    let condition: WeatherCondition
    var size: CGFloat = 24
    
    var body: some View {
        switch condition {
        case .clear:
            SunIcon(size: size)
        case .cloudy:
            CloudyIcon(size: size)
        case .overcast:
            OvercastIcon(size: size)
        case .snowing:
            SnowingIcon(size: size)
        }
    }
}

// MARK: - Previews
struct WeatherIcons_Previews: PreviewProvider {
    static var previews: some View {
        HStack(spacing: 20) {
            VStack {
                SunIcon(size: 48)
                Text("Clear")
            }
            VStack {
                CloudyIcon(size: 48)
                Text("Cloudy")
            }
            VStack {
                OvercastIcon(size: 48)
                Text("Overcast")
            }
            VStack {
                SnowingIcon(size: 48)
                Text("Snowing")
            }
        }
        .padding()
        .background(AppColors.background)
    }
}
