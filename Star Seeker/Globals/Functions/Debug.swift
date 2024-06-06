import Foundation
import os

func debug ( _ message: String ) {
    if ( AppConfig.debug ) {
        Logger.shared.log("\(message)")
    }
} 
