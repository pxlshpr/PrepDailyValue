import PrepShared

public struct DailyValue {
    public let micro: Micro
    public let unit: NutrientUnit
    public let type: DailyValueType
    public let goalType: DailyValueGoalType
    public let source: DailyValueSource?
    public let url: String?
    public let goals: [DailyValueGoal]
    
    public init(
        micro: Micro,
        unit: NutrientUnit,
        type: DailyValueType,
        source: DailyValueSource? = nil,
        url: String? = nil,
        goalType: DailyValueGoalType,
        goals: [DailyValueGoal]
    ) {
        self.micro = micro
        self.unit = unit
        self.goals = goals
        self.type = type
        self.source = source
        self.url = url
        self.goalType = goalType
    }
    
    //TODO: Do these in order
    /// [x] First try and represent a couple of DailyValue's here
    /// [x] Basic fixed one
    /// [x] One with table of values for different params
    /// [x] One with grams/energy like fiber
    /// [x] One with percentage of energy like transFat
    /// [x] Add a field in `DailyValue` that lets us link to the `DailyValueSourcePreset` enum (hardcoded in app, not recommended), or links to another entity we will have in addition to this (preferable, as its updatabale remotely)
    /// [x] Move the `DailValueGoalType` field from `DailyValueGoal` to `DailyValue` itself to avoid repetition
    /// [ ] Implement the bound function below and test calculating it
    /// [ ] Create the `DailyValueSource` struct with fields we woudl want to use
    /// [ ] Create test sources for NIH etc (all the ones used in examples) and actually link them
    /// [ ] Design how we will display each one when Choosing and setting cell
    /// [x] Consider packaging this up in a separate package that we can test etc
    /// [ ] Store the sources and DailyValue's themselves in the Public Database and have them synced to user devices (with metadata like isTrashed etc)
    /// [ ] When viewing previous days—always use closest biometrics leading up to this day if available (as params)
    /// [ ] Include the DailyValueParams fields in Biometrics, and have a quick accessor for it, returning the values stored in it and also a dynamic age if possible

    public func bound(
        params: DailyValueParams = .init(),
        energyInKcal: Double? = nil
    ) -> GoalBound? {
        
        /// If the goal type is based on energy and we don't have one, stop here
        if goalType.usesEnergy {
            guard energyInKcal != nil else { return nil }
        }
        
        /// Go through the goals and find a compatible one matching the provided params and energyInKcal
        for goal in goals {

            /// If goal has params set (like age range etc), and we don't have them available, disqualify the goal and continue
            if let ageRange = goal.ageRange {
                guard let age = params.age, ageRange.contains(age) else { continue }
            }
            if let gender = goal.gender {
                guard params.gender == gender else { continue }
            }
            if let isPregnant = goal.isPregnant {
                guard params.isPregnant == isPregnant else { continue }
            }
            if let isLactating = goal.isLactating {
                guard params.isLactating == isLactating else { continue }
            }
            if let isSmoker = goal.isSmoker {
                guard params.isSmoker == isSmoker else { continue }
            }

            /// Calculate the goal (if not fixed) or return the bound of the goal itself
            switch goalType {
            case .fixed:
                return goal.bound
                
            case .quantityPerEnergy(let double, let energyUnit):
                guard let energyInKcal else { return nil }
                let converted = energyUnit.convert(double, to: .kcal)
                
                return switch (goal.bound.lower, goal.bound.upper) {
                case (.some(let lower), .some(let upper)):
                    GoalBound(
                        lower: (lower * energyInKcal) / converted,
                        upper: (upper * energyInKcal) / converted
                    )
                case (.some(let lower), nil):
                    GoalBound(
                        lower: (lower * energyInKcal) / converted
                    )
                case (nil, .some(let upper)):
                    GoalBound(
                        upper: (upper * energyInKcal) / converted
                    )
                case (.none, .none):
                    nil
                }

            case .percentageOfEnergy:
                guard let energyInKcal else { return nil }
                
                let kcalsPerGram: Double? = switch micro.group {
                case .fats: KcalsPerGramOfFat
                default:    nil
                }
                
                guard let kcalsPerGram else { return nil }
                
                return switch (goal.bound.lower, goal.bound.upper) {
                case (.some(let lower), .some(let upper)):
                    GoalBound(
                        lower: ((lower/100.0) * energyInKcal) / kcalsPerGram,
                        upper: ((upper/100.0) * energyInKcal) / kcalsPerGram
                    )
                case (.some(let lower), nil):
                    GoalBound(
                        lower: ((lower/100.0) * energyInKcal) / kcalsPerGram
                    )
                case (nil, .some(let upper)):
                    GoalBound(
                        upper: ((upper/100.0) * energyInKcal) / kcalsPerGram
                    )
                case (.none, .none):
                    nil
                }
            }
        }
        
        /// No compatible goal found
        return nil
    }
}
