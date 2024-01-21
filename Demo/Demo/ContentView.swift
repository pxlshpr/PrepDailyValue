import SwiftUI
import PrepDailyValue
import PrepShared
import PrepSettings


struct ContentView: View {
    
    @State var settingsProvider = SettingsProvider.shared
//    @State var healthProvider: HealthProvider = MockHealthModel
    
    init() {
//        SettingsProvider.configureAsMock()
    }
    
    var body: some View {
        MicrosSettings()
            .environment(settingsProvider)
    }
}

#Preview {
    ContentView()
}
