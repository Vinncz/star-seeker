import Foundation
import Observation

@Observable class RestrictionGroup {
    var list: [String: Restriction]
    
    func contains ( _ key: String ) -> Bool {
        return list[key]?.check() ?? false
    }
    
    convenience init () {
        self.init([:])
    }
    
    init ( _ dictionary : [String : Restriction] ) {
        self.list = dictionary
    }
}
