import Foundation
import os

extension Logger {
    
    private static var subsystem = Bundle.main.bundleIdentifier!
    static let shared = Logger(subsystem: subsystem, category: Bundle.main.appName ?? "Star Seeker")
    
}
