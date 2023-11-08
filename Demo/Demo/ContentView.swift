import SwiftUI
import PrepDailyValue
import PrepShared
import PrepSettings

struct ContentView: View {
    
    @State var settingsStore = SettingsStore.shared
    @State var healthModel: HealthModel = MockHealthModel
    
    init() {
        SettingsStore.configureAsMock()
    }
    
    var body: some View {
        MicrosSettings()
            .environment(settingsStore)
    }
}

#Preview {
    ContentView()
}
