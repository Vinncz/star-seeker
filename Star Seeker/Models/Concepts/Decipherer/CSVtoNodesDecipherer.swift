import SpriteKit

class CSVtoNodesDecipherer : Decipherer {
    let id = UUID()
    private var csvFileName        : String
    private var nodeConfigurations : [String: (Season) -> SKSpriteNode]
    
    init ( csvFileName: String, nodeConfigurations: [String: (Season) -> SKSpriteNode] ) {
        self.csvFileName        = csvFileName
        self.nodeConfigurations = nodeConfigurations
    }
    
    func decipher () -> ( result: Any, error: (any Error)? ) {
        let (resource, error) = accessResource(named: csvFileName, format: "csv")
        guard ( error == nil ) else { return ([], error) }
        
        let csvContent = resource as? String ?? ""
        var result     : [[SKSpriteNode?]] = []
        
        let rows = csvContent.components(separatedBy: AppConfig.newLineCharacter)
        for row in rows {
            var rowResult: [SKSpriteNode?] = []

            let columns = row.components(separatedBy: AppConfig.delimiter)
            for c in columns {
                let column = c.trimmingCharacters(in: .whitespacesAndNewlines)
                guard ( !column.isEmpty && column.count > 1 ) else { 
                    rowResult.append(nil); 
                    continue 
                }
                
                let rawResult        = column.split(separator: "-")
                let rawData          = rawResult[0]
                let seasonalModifier : Season
                
                if ( rawResult.count > 1  ) {
                    let rawModifier = rawResult[1]
                    switch ( rawModifier ) {
                        case "au":
                            seasonalModifier = .autumn
                        case "wi":
                            seasonalModifier = .winter
                        case "sp":
                            seasonalModifier = .spring
                        case "su":
                            seasonalModifier = .summer
                        default:
                            seasonalModifier = .notApplicable
                    }
                    
                } else {
                    seasonalModifier = .notApplicable
                    
                }
                
                if let nodeType = nodeConfigurations[String(rawData)] {
                    let node: SKSpriteNode? = nodeType(seasonalModifier)
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
