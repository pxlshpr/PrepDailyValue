import PrepShared

public struct DailyValueParams {
    public var age: Int? = nil
    public var gender: BiometricSex? = nil
    public var isPregnant: Bool? = nil
    public var isLactating: Bool? = nil
    public var isSmoker: Bool? = nil
    
    public init(
        age: Int? = nil,
        gender: BiometricSex? = nil,
        isPregnant: Bool? = nil,
        isLactating: Bool? = nil,
        isSmoker: Bool? = nil
    ) {
        self.age = age
        self.gender = gender
        self.isPregnant = isPregnant
        self.isLactating = isLactating
        self.isSmoker = isSmoker
    }
}
