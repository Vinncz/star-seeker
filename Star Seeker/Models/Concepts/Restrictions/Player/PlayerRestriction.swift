import Foundation

class PlayerRestriction : Restriction {
    let checker : () -> Bool
    func check () -> Bool {
        return self.checker()
    }
    
    init ( comparer: @escaping () -> Bool ) {
        self.checker = comparer
    }
}
