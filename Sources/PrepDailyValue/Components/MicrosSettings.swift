import SwiftUI
import PrepShared
import PrepSettings

public struct MicrosSettings: View {
    
    @Environment(SettingsProvider.self) var settingsProvider: SettingsProvider

    public init() {
        
    }
    
    public var body: some View {
        NavigationStack {
            Form {
                ForEach(MicroGroup.allCases, id: \.self) { group in
                    Section(group.name) {
                        ForEach(group.micros, id: \.self) { micro in
                            NavigationLink {
                                MicroSettings(micro, settingsProvider)
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
