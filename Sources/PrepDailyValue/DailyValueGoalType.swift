import PrepShared

public enum DailyValueGoalType {
    case fixed
    case quantityPerEnergy(Double, EnergyUnit)
    case percentageOfEnergy
}

public extension DailyValueGoalType {
    var usesEnergy: Bool {
        switch self {
        case .quantityPerEnergy, .percentageOfEnergy:   true
        default:                                        false
        }
    }
}
