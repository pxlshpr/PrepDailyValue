import XCTest
import PrepShared
@testable import PrepDailyValue

final class PrepDailyValueTests: XCTestCase {
    func testExample() throws {
        
        for testCase in testCases {
            let bound = testCase.dailyValue.bound(params: testCase.params, energyInKcal: testCase.energyInKcal)
            XCTAssertEqual(bound, testCase.expectedBound)
        }
    }
}

struct TestCase {
    let dailyValue: DailyValue
    let params: DailyValueParams
    let energyInKcal: Double?
    let expectedBound: GoalBound?
    
    init(
        dailyValue: DailyValue,
        params: DailyValueParams = .init(),
        energyInKcal: Double? = nil,
        expectedBound: GoalBound?
    ) {
        self.dailyValue = dailyValue
        self.params = params
        self.energyInKcal = energyInKcal
        self.expectedBound = expectedBound
    }
}

let testCases: [TestCase] = [
    .init(
        dailyValue: fiber_eatRight,
        energyInKcal: 2000,
        expectedBound: l(28)
    ),
    .init(
        dailyValue: fiber_mayoClinic,
        params: .init(gender: .male),
        expectedBound: b(30, 38)
    ),
    .init(
        dailyValue: fiber_mayoClinic,
        expectedBound: nil /// no gender so we're unable to infer this
    ),
]

let fiber_mayoClinic = DailyValue(
    micro: .dietaryFiber,
    unit: .g,
    type: .preset,
    url: "https://www.mayoclinic.org/healthy-lifestyle/nutrition-and-healthy-eating/in-depth/high-fiber-foods/art-20050948",
    goalType: .fixed,
    goals: [
        g(b(21, 25), gender: .female),
        g(b(30, 38), gender: .male),
    ]
)

let fiber_eatRight = DailyValue(
    micro: .dietaryFiber,
    unit: .g,
    type: .preset,
    url: "https://www.eatright.org/health/essential-nutrients/carbohydrates/fiber",
    goalType: .quantityPerEnergy(1000, .kcal),
    goals: [
        g(l(14)),
    ]
)

let transFat_who = DailyValue(
    micro: .transFat,
    unit: .g,
    type: .preset,
    url: "https://www.who.int/news-room/questions-and-answers/item/nutrition-trans-fat",
    goalType: .percentageOfEnergy,
    goals: [
        g(u(1)),
    ]
)

let vitaminC_nih = DailyValue(
    micro: .vitaminC_ascorbicAcid,
    unit: .mg,
    type: .preset,
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

//TODO: Add more cases like fiber for per energy, fixed, etc.

func g(
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

func b(_ lower: Double, _ upper: Double) -> GoalBound {
    GoalBound(lower: lower, upper: upper)
}

func l(_ lower: Double) -> GoalBound {
    GoalBound(lower: lower)
}

func u(_ upper: Double) -> GoalBound {
    GoalBound(upper: upper)
}
