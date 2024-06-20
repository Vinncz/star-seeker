import SpriteKit

enum DecipherError: Error {
    case fileNotFound
    case fileNotReadable
}

class CSVDecipherer : Decipherer {
    
    private var csvFileName        : String
    private var nodeConfigurations : [String: () -> SKSpriteNode]
    
    init ( csvFileName: String, nodeConfigurations: [String: () -> SKSpriteNode] ) {
        self.csvFileName        = csvFileName
        self.nodeConfigurations = nodeConfigurations
    }
    
    func decipher () -> (Any, (any Error)?) {
        var csvContent : String
        
        guard let fileURL = Bundle.main.url(forResource: csvFileName, withExtension: "csv") else {
            return ([], DecipherError.fileNotFound)
        }

        do {
            let resourceValues = try fileURL.resourceValues(forKeys: [.isReadableKey])
            if resourceValues.isReadable ?? false {
                let data = try Data(contentsOf: fileURL)
                csvContent = String(data: data, encoding: .utf8) ?? ""
            } else {
                return ([], DecipherError.fileNotReadable)
            }
        } catch {
            return ([], error)
        }
        
        var result : [[SKSpriteNode?]] = []
        
        let rows = csvContent.components(separatedBy: AppConfig.newLineCharacter)
        for row in rows {
            var rowResult: [SKSpriteNode?] = []

            let columns = row.components(separatedBy: AppConfig.delimiter)
            for column in columns {
                if let nodeType = nodeConfigurations[column] {
                    let node: SKSpriteNode? = nodeType()
                    rowResult.append(node)
                    
                } else {
                    rowResult.append(nil)
                    
                }
            }
            
            result.append(rowResult)
        }
        
        return (result, nil)
    }
}
