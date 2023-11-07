import SwiftUI
import PrepDailyValue
import PrepShared
import PrepSettings

struct ContentView: View {
    
    @State var settingsStore = SettingsStore.shared
    @State var biometricsStore: BiometricsStore
    
    init() {
        let biometricsStore = BiometricsStore(
            currentBiometricsHandler: Self.fetchBiometrics,
            saveHandler: Self.saveBiometrics
        )
        _biometricsStore = State(initialValue: biometricsStore)
        SettingsStore.configure(
            fetchHandler: Self.fetchSettings,
            saveHandler: Self.saveSettings
        )
    }
    
    var body: some View {
        MicrosSettings()
            .environment(settingsStore)
    }
}

extension ContentView {

    static func fetchBiometrics() async throws -> Biometrics {
        let url = getDocumentsDirectory().appendingPathComponent("biometrics.json")
        do {
            let data = try Data(contentsOf: url)
            let biometrics = try JSONDecoder().decode(Biometrics.self, from: data)
            return biometrics
        } catch {
            return .init()
        }
    }
    
    static func saveBiometrics(_ biometrics: Biometrics, isCurrent: Bool) async throws {
        let url = getDocumentsDirectory().appendingPathComponent("biometrics.json")
        let json = try JSONEncoder().encode(biometrics)
        try json.write(to: url)
    }
    
    static func fetchSettings() async throws -> Settings {
        let url = getDocumentsDirectory().appendingPathComponent("settings.json")
        do {
            let data = try Data(contentsOf: url)
            let settings = try JSONDecoder().decode(Settings.self, from: data)
            return settings
        } catch {
            return .default
        }
    }
    
    static func saveSettings(_ settings: Settings) async throws {
        let url = getDocumentsDirectory().appendingPathComponent("settings.json")
        let json = try JSONEncoder().encode(settings)
        try json.write(to: url)
    }
    
    static func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}

#Preview {
    ContentView()
}
