import PrepShared

public enum DailyValueSource {
    case preset
    case custom
}

public extension DailyValueSource {
    var name: String {
        switch self {
        case .preset: "Preset"
        case .custom: "Custom"
        }
    }
}

extension DailyValueSource: Pickable {
    public var pickedTitle: String { name }
    public var menuTitle: String { name }
    public static var `default`: DailyValueSource {
        .preset
    }
}
