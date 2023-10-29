import PrepShared

public enum PresetDailyValueType: Hashable, Equatable, Codable {
    case fixed
    case quantityPerEnergy(Double, EnergyUnit)
    case percentageOfEnergy
}

public extension PresetDailyValueType {
    var usesEnergy: Bool {
        switch self {
        case .quantityPerEnergy, .percentageOfEnergy:   true
        default:                                        false
        }
    }
}
