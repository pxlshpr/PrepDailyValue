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

//MARK: - Daily Values for Test Cases

public let vitaminC_nih = DailyValue(
    micro: .vitaminC_ascorbicAcid, unit: .mg, type: .preset,
    source: .nih,
    url: "https://ods.od.nih.gov/factsheets/VitaminC-Consumer/",
    goalType: .fixed,
    goals: [
        g(l(40), ageRange: b(0, 0.5)),
        g(l(50), ageRange: b(0.5, 1.0)),
        g(b(15, 400), ageRange: b(1, 4)),
        g(b(25, 650), ageRange: b(4, 9)),
        g(b(45, 1200), ageRange: b(9, 14)),
        g(b(75, 1800), ageRange: b(14, 19), gender: .male),
        g(b(65, 1800), ageRange: b(14, 19), gender: .female, pregnant: false, lactating: false),
        g(b(80, 1800), ageRange: b(14, 19), gender: .female, pregnant: true, lactating: false),
        g(b(115, 1800), ageRange: b(14, 19), gender: .female, pregnant: false, lactating: true),
        g(b(90, 2000), ageRange: l(19), gender: .male, smoker: false),
        g(b(125, 2000), ageRange: l(19), gender: .male, smoker: true),
        g(b(75, 2000), ageRange: l(19), gender: .female, pregnant: false, lactating: false, smoker: false),
        g(b(110, 2000), ageRange: l(19), gender: .female, pregnant: false, lactating: false, smoker: true),
        g(b(85, 2000), ageRange: l(19), gender: .female, pregnant: true, lactating: false, smoker: false),
        g(b(120, 2000), ageRange: l(19), gender: .female, pregnant: false, lactating: true, smoker: false),
    ]
)

public let transFat_who = DailyValue(
    micro: .transFat, unit: .g, type: .preset,
    source: .who,
    url: "https://www.who.int/news-room/questions-and-answers/item/nutrition-trans-fat",
    goalType: .percentageOfEnergy,
    goals: [
        g(u(1)),
    ]
)

public let fiber_mayoClinic = DailyValue(
    micro: .dietaryFiber, unit: .g, type: .preset,
    source: .mayoClinic,
    url: "https://www.mayoclinic.org/healthy-lifestyle/nutrition-and-healthy-eating/in-depth/high-fiber-foods/art-20050948",
    goalType: .fixed,
    goals: [
        g(b(21, 25), gender: .female),
        g(b(30, 38), gender: .male),
    ]
)

public let fiber_eatRight = DailyValue(
    micro: .dietaryFiber, unit: .g, type: .preset,
    source: .eatRight,
    url: "https://www.eatright.org/health/essential-nutrients/carbohydrates/fiber",
    goalType: .quantityPerEnergy(1000, .kcal),
    goals: [
        g(l(14)),
    ]
)

//MARK: - Helpers

public func g(
    _ bound: GoalBound,
    ageRange: GoalBound? = nil,
    gender: BiometricSex? = nil,
    pregnant: Bool? = nil,
    lactating: Bool? = nil,
    smoker: Bool? = nil
) -> DailyValueGoal {
    DailyValueGoal(
        bound: bound,
        ageRange: ageRange,
        gender: gender,
        isPregnant: pregnant,
        isLactating: lactating,
        isSmoker: smoker
    )
}

public func b(_ lower: Double, _ upper: Double) -> GoalBound {
    GoalBound(lower: lower, upper: upper)
}

public func l(_ lower: Double) -> GoalBound {
    GoalBound(lower: lower)
}

public func u(_ upper: Double) -> GoalBound {
    GoalBound(upper: upper)
}
