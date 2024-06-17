import Foundation
import SpriteKit
import os

class CSVDecipherer : Decipherer {
    
    private var csvPath            : String
    private var nodeConfigurations : [String: () -> SKSpriteNode]
    
    init ( path: String, nodeConfigurations: [String: () -> SKSpriteNode] ) {
        self.csvPath            = path
        self.nodeConfigurations = nodeConfigurations
    }
    
    func decipher () -> Any {
        let csvContent : String = 
        """
        ;;;;;;;;;;
        ;;;;;;;;;;
        ;;;;;;;;;;
        ;;;;;;;;;;
        ;;;;;;;;;;
        ;;;;;;;;;;
        ;;;pFN;pFN;pFN;pFN;;;;
        ;;;;;;;;;;
        ;;;;;;;;PLY;;
        ;pBP;;;;;;pBP;pBP;;
        ;pBP;pBP;pBP;;;;;pBP;pBP;
        ;;;;;;;;;;
        ;;;pTM;pMV;pMV;pMV;pTM;;;
        ;;;;;;;;;;
        pBP;pBP;;;;;;;;;pBP
        ;pBP;pBP;pBP;;;;pBP;pBP;pBP;pBP
        ;;;;;;;;;;
        ;;;;pBG;pBG;pBG;;;;
        ;;;;;;;;;;
        ;;;;;;;;;;
        ;;;;;;;;;;
        ;;;;;;;;;;
        ;;;;;;;;;;
        """
//        do {
//            csvContent = try String(contentsOfFile: csvPath, encoding: .utf8)
//        } catch {
//            print("File not found. \(error)")
//            csvContent = ""
//        }
        
        var result : [[SKSpriteNode?]] = []
        
        let rows = csvContent.components( separatedBy: AppConfig.newLineCharacter )
        for row in rows {
            var rowResult: [SKSpriteNode?] = []

            let columns = row.components( separatedBy: AppConfig.delimiter )
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
        
        return result
    }
}
