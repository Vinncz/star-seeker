//
//  PlaySound.swift
//  Star Seeker
//
//  Created by Elian Richard on 23/06/24.
//

import AVKit

enum SoundOptionEnum: String {
    case Button, Button2, GameOver, PlatformCollision, SlingshotPull, SlingshotRelease
}
class SoundManager {
    static let instance = SoundManager()
    
    var player: AVAudioPlayer?
    
    func playSound(_ sound: SoundOptionEnum) {
        guard let url = Bundle.main.url(forResource: sound.rawValue, withExtension: "mp3") else { return }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch let error {
            print("Error playing sound, \(error.localizedDescription)")
        }
    }
}
