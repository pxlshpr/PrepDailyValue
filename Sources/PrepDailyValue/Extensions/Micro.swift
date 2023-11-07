import PrepShared

extension Micro {
    var rdis: [RDI] {
        switch self {
        case .dietaryFiber:
            [fiber_eatRight, fiber_mayoClinic]
        case .transFat:
            [transFat_who]
        default:
            []
        }
    }
}
