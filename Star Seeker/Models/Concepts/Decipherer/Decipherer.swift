import Foundation

protocol Decipherer {
    func accessResource ( named: String, format: String ) -> (Any, Error?)
    func decipher () -> (Any, Error?)
}

extension Decipherer {
    
    /** Provides a basic implmentation for accessing a string-based file */
    func accessResource ( named: String, format: String = "" ) -> (Any, Error?) {
        guard let fileURL = Bundle.main.url(forResource: named, withExtension: format) else {
            return ([], DecipherError.fileNotFound)
        }

        var fileContent : String
        do {
            let resourceValues = try fileURL.resourceValues(forKeys: [.isReadableKey])
            if ( resourceValues.isReadable ?? false ) {
                let data = try Data(contentsOf: fileURL)
                fileContent = String(data: data, encoding: .utf8) ?? ""
            } else {
                return ([], DecipherError.fileNotReadable)
            }
        } catch {
            return ([], error)
        }
        
        return (fileContent, nil)
    }
    
}

enum DecipherError : Error {
    case fileNotFound
    case fileNotReadable
}
