import SpriteKit

class CSVtoMovingPlatformDecipherer : Decipherer {
    let id = UUID()
    private var csvFileName        : String
    private var nodeConfigurations : [String: (Season, CGVector) -> SKSpriteNode]
    
    init ( csvFileName: String, movingPlatformConfigurrations: [String: (Season, CGVector) -> SKSpriteNode] ) {
        self.csvFileName        = csvFileName
        self.nodeConfigurations = movingPlatformConfigurrations
    }
    
    func decipher () -> ( result: Any, error: (any Error)?) {
        let (resource, error) = accessResource(named: csvFileName, format: "csv")
        guard ( error == nil ) else { return ([], error) }
        
        let csvContent = resource as? String ?? ""
        var result     : [[SKSpriteNode?]] = []
        
        let rows = csvContent.components(separatedBy: AppConfig.newLineCharacter)
        for row in rows {
            var rowResult: [SKSpriteNode?] = []

            let columns = row.components(separatedBy: AppConfig.delimiter)
            for c in columns {
                var movementVector : CGVector = CGVector(dx: 0, dy: 0)
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
                    
                    if ( rawResult.count > 2 ) {
                        let distance = rawResult[2].split(separator: ":")
                        guard ( distance.count > 1 ) else { break }
                        let dx = CGFloat(integerLiteral: Int(distance[0]) ?? 0)
                        let dy = CGFloat(integerLiteral: Int(distance[1]) ?? 0)
                        movementVector = CGVector(dx: dx * ValueProvider.gridDimension.width, dy: dy * ValueProvider.gridDimension.height)
                    }
                } else {
                    seasonalModifier = .notApplicable
                }
                
                if let nodeType = nodeConfigurations[String(rawData)] {
                    let node: SKSpriteNode? = nodeType(seasonalModifier, movementVector)
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
