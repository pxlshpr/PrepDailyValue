import PrepShared

enum PickableBool {
    case yes
    case no
    case notSpecified
    
    var title: String {
        switch self {
        case .yes: "Yes"
        case .no: "No"
        case .notSpecified: "Not specified"
        }
    }
}

extension PickableBool: Pickable {
    var pickedTitle: String { title }
    var menuTitle: String { title }
    static var `default`: PickableBool { .notSpecified }
    static var noneOption: PickableBool? { .notSpecified }
}
