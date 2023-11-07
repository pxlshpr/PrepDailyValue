import SwiftUI
import PrepShared
import PrepSettings

public struct MicrosSettings: View {
    
    @Environment(SettingsStore.self) var settingsStore: SettingsStore

    public init() {
        
    }
    
    public var body: some View {
        NavigationStack {
            Form {
                ForEach(MicroGroup.allCases, id: \.self) { group in
                    Section(group.name) {
                        ForEach(group.micros, id: \.self) { micro in
                            NavigationLink {
                                MicroSettings(micro, settingsStore)
                            } label: {
                                Text(micro.name)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Micronutrients")
        }
    }
}
