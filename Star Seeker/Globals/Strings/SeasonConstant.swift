import Foundation

struct SeasonConstant {
    static let spring : String = "VERTEX.STAR_SEEKER.SEASON.SPRING"
    static let summer : String = "VERTEX.STAR_SEEKER.SEASON.SUMMER"
    static let autumn : String = "VERTEX.STAR_SEEKER.SEASON.AUTUMN"
    static let winter : String = "VERTEX.STAR_SEEKER.SEASON.WINTER"
}

enum Season : String {
    case spring = "spring."
    case summer = "summer."
    case autumn = "autumn."
    case winter = "winter."
    case notApplicable = "n/a"
}
