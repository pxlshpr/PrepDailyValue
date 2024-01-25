import SwiftUI
import PrepDailyValue
import PrepShared
import PrepSettings


struct ContentView: View {
    
    @State var provider = Provider.shared
    
    init() { }
    
    var body: some View {
        MicrosSettings()
            .environment(provider)
    }
}

#Preview {
    ContentView()
}
