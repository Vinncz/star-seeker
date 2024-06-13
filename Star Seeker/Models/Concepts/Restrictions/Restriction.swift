import Foundation

protocol Restriction {
    var checker : () -> Bool { get }
    func check () -> Bool
}

enum RestrictionState {
    case active,
         nonactive
}
