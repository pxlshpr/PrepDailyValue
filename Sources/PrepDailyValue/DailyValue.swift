import PrepShared

public struct DailyValue {
    public let micro: Micro
    public let unit: NutrientUnit
    public let goals: [DailyValueGoal]
    public let source: DailyValueSource
    public let link: String
    
    public init(
        micro: Micro,
        unit: NutrientUnit,
        goals: [DailyValueGoal],
        source: DailyValueSource,
        link: String
    ) {
        self.micro = micro
        self.unit = unit
        self.goals = goals
        self.source = source
        self.link = link
    }
    
    //TODO: Do these in order
    /// [ ] First try and represent a couple of DailyValue's here
    /// [ ] Basic fixed one
    /// [ ] One with table of values for different params
    /// [ ] One with grams/energy like fiber
    /// [ ] One with percentage of energy like transFar
    /// [ ] Now test displaying these when Choosing and setting cell
    /// [ ] Then do the bound function below and test calculating it
    /// [ ] Consider packaging this up in a separate package that we can test etc
    /// [ ] Now consider a way we can store the sources and DailyValue's themselves in the Public Database and have them synced to user devices
    /// [ ] Consider having a soft deleted isTrashed flag for each so that we can 'remove' them by trashing them
    public func bound(
        params: DailyValueParams = .init(),
        energyInKcal: Double? = nil
    ) -> GoalBound? {
        /// This should go through the goals and find a compatible one matching the provided params and energyInKcal
        /// [ ] Go through all the goals and
        /// [ ] If goal has params set (like age range etc), and we don't have them available, disqualify the goal and continuee
        /// [ ] If goal is quantityPer or percentageOf energy and we don't have one, disquality the goal and continue
        /// [ ] Otherwise, either calculate the goal (if not fixed) or return the bound of the goal itself
        ///
        /// [ ] When viewing previous days—always use closest biometrics leading up to this day if available (as params)
        /// [ ] Include the DailyValueParams fields in Biometrics, and have a quick accessor for it, returning the values stored in it and also a dynamic age if possible
        GoalBound(lower: nil, upper: nil)
    }
}
