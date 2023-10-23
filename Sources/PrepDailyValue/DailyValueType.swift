import PrepShared

public enum DailyValueType: Int, CaseIterable, Codable {
    case preset
    case custom
}

public extension DailyValueType {
    var name: String {
        switch self {
        case .preset: "Preset"
        case .custom: "Custom"
        }
    }
}

extension DailyValueType: Pickable {
    public var pickedTitle: String { name }
    public var menuTitle: String { name }
    public static var `default`: DailyValueType {
        .preset
    }
}
