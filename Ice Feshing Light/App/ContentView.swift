import SwiftUI

enum AppScreen {
    case quickRecord
    case calendar
    case statistics
    case charts
    case comparison
    case settings
}

struct ContentView: View {
    @StateObject private var dataService = DataService.shared
    @StateObject private var settingsService = SettingsService.shared
    
    @State private var currentScreen: AppScreen = .quickRecord
    
    var body: some View {
        ZStack {
            switch currentScreen {
            case .quickRecord:
                QuickRecordView(
                    dataService: dataService,
                    settingsService: settingsService
                ) {
                    currentScreen = .calendar
                }
                .transition(.move(edge: .leading))
                
            case .calendar:
                CalendarHistoryView(
                    dataService: dataService,
                    settingsService: settingsService,
                    onNavigateToStats: {
                        currentScreen = .statistics
                    },
                    onNavigateBack: {
                        currentScreen = .quickRecord
                    }
                )
                .transition(.move(edge: .trailing))
                
            case .statistics:
                StatisticsView(
                    dataService: dataService,
                    settingsService: settingsService,
                    onNavigateToCharts: {
                        currentScreen = .charts
                    },
                    onNavigateBack: {
                        currentScreen = .calendar
                    }
                )
                .transition(.move(edge: .trailing))
                
            case .charts:
                ChartsView(
                    dataService: dataService,
                    onNavigateToComparison: {
                        currentScreen = .comparison
                    },
                    onNavigateBack: {
                        currentScreen = .statistics
                    }
                )
                .transition(.move(edge: .trailing))
                
            case .comparison:
                ComparisonView(
                    dataService: dataService,
                    onNavigateToSettings: {
                        currentScreen = .settings
                    },
                    onNavigateBack: {
                        currentScreen = .charts
                    }
                )
                .transition(.move(edge: .trailing))
                
            case .settings:
                SettingsView(
                    settingsService: settingsService,
                    onNavigateBack: {
                        currentScreen = .comparison
                    }
                )
                .transition(.move(edge: .trailing))
            }
        }
        .animation(.easeInOut(duration: 0.25), value: currentScreen)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
