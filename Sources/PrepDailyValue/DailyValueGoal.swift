import PrepShared

public struct DailyValueGoal {
    public var type: DailyValueGoalType
    public var bound: GoalBound
    public var ageRange: ClosedRange<Double>? = nil
    public var gender: BiometricSex? = nil
    public var isPregnant: Bool? = nil
    public var isLactating: Bool? = nil
    public var isSmoker: Bool? = nil
    
    public init(
        type: DailyValueGoalType,
        bound: GoalBound,
        ageRange: ClosedRange<Double>? = nil,
        gender: BiometricSex? = nil,
        isPregnant: Bool? = nil,
        isLactating: Bool? = nil,
        isSmoker: Bool? = nil
    ) {
        self.type = type
        self.bound = bound
        self.ageRange = ageRange
        self.gender = gender
        self.isPregnant = isPregnant
        self.isLactating = isLactating
        self.isSmoker = isSmoker
    }
    
    public init(
        _ type: DailyValueGoalType,
        _ bound: GoalBound,
        ageRange: ClosedRange<Double>? = nil,
        gender: BiometricSex? = nil,
        isPregnant: Bool? = nil,
        isLactating: Bool? = nil,
        isSmoker: Bool? = nil
    ) {
        self.type = type
        self.bound = bound
        self.ageRange = ageRange
        self.gender = gender
        self.isPregnant = isPregnant
        self.isLactating = isLactating
        self.isSmoker = isSmoker
    }
}

let vitaminC = DailyValue(
    micro: .vitaminC_ascorbicAcid,
    unit: .mg,
    goals: [
        .init(.fixed, .init(lower: 40), ageRange: 0...0.5)
    ],
    source: .preset,
    //TODO: Add source here (NIH in this case)
    link: "https://ods.od.nih.gov/factsheets/VitaminC-Consumer/"
)
