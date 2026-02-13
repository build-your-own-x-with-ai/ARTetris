
import AVFoundation

class AudioManager {
    static let shared = AudioManager()
    
    private var bgmPlayer: AVAudioPlayer?
    private var sfxPlayers: [String: AVAudioPlayer] = [:]
    
    private init() {}
    
    private func getURL(for name: String) -> URL? {
        if let url = Bundle.main.url(forResource: name, withExtension: "mp3") {
            return url
        }
        if let url = Bundle.main.url(forResource: name, withExtension: "wav") {
            return url
        }
        return nil
    }
    
    func startBGM() {
        guard let url = getURL(for: "bgm") else {
            print("BGM file not found.")
            return
        }
        
        do {
            bgmPlayer = try AVAudioPlayer(contentsOf: url)
            bgmPlayer?.numberOfLoops = -1 // Loop indefinitely
            bgmPlayer?.volume = 0.5
            bgmPlayer?.play()
        } catch {
            print("Could not load BGM: \(error)")
        }
    }
    
    func stopBGM() {
        bgmPlayer?.stop()
    }
    
    func playSound(_ name: String) {
        // If we already have a player for this sound, try to reuse it if not playing
        if let existingPlayer = sfxPlayers[name], !existingPlayer.isPlaying {
            existingPlayer.play()
            return
        }
        
        guard let url = getURL(for: name) else {
            // print("Sound file \(name) not found.")
            return
        }
        
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.volume = 1.0
            player.play()
            sfxPlayers[name] = player
        } catch {
            print("Could not load sound \(name): \(error)")
        }
    }
}
