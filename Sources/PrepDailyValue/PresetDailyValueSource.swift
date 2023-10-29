import PrepShared

public enum PresetDailyValueSource: Int, CaseIterable, Codable {
    case who
    case nhs
    case nih
    case webMD
    case harvardTHChan
    case mayoClinic
    case healthline
    case medlinePlus
    case eatRight
}

public extension PresetDailyValueSource {
    
    var abbreviation: String {
        switch self {
        case .who:              "WHO"
        case .nhs:              "NHS"
        case .nih:              "NIH"
        case .webMD:            "WebMD"
        case .harvardTHChan:    "Harvard T.H. Chan"
        case .mayoClinic:       "Mayo Clinic"
        case .healthline:       "HealthLine"
        case .medlinePlus:      "MedlinePlus"
        case .eatRight:         "EatRight"
        }
    }

    var name: String {
        switch self {
        case .who:              "World Health Organization"
        case .nhs:              "National Health Service"
        case .nih:              "National Institutes of Health"
        case .webMD:            "WebMD"
        case .harvardTHChan:    "Harvard T.H. Chan"
        case .mayoClinic:       "Mayo Clinic"
        case .healthline:       "HealthLine"
        case .medlinePlus:      "MedlinePlus"
        case .eatRight:         "EatRight"
        }
    }
//
//    var governingBody: String {
//        switch self {
//        case .who:      "United Nations"
//        case .nhs:      "England, UK"
//        case .nih:      "United States"
//        case .webmd:    "United States"
//        }
//    }
}
