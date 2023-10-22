import PrepShared

public enum DailyValueGoalType {
    case fixed
    case quantityPerEnergy(Double, EnergyUnit)
    case percentageOfEnergy
}
