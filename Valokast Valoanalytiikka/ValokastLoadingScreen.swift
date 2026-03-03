import SwiftUI

struct ValokastLoadingScreen: View {
    @State private var glowOpacity: Double = 0.3
    
    var body: some View {
        ZStack {
            AppTheme.backgroundPrimary
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                SunShape()
                    .stroke(AppTheme.amber, lineWidth: 2.5)
                    .frame(width: 60, height: 60)
                    .opacity(glowOpacity)
                
                Text("Valokast")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(AppTheme.warmWhite)
                
                Text("Valoanalytiikka")
                    .font(.subheadline)
                    .foregroundColor(AppTheme.amber)
                
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: AppTheme.amber))
                    .scaleEffect(1.2)
                    .padding(.top, 16)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                glowOpacity = 1.0
            }
        }
    }
}
