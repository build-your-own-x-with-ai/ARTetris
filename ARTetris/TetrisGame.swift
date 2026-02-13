
import SwiftUI
import Combine

class TetrisGame: ObservableObject {
    @Published var grid: [[Color?]] = Array(repeating: Array(repeating: nil, count: 10), count: 20)
    @Published var currentPiece: Tetromino?
    @Published var nextPiece: Tetromino?
    @Published var score: Int = 0
    @Published var isGameOver: Bool = false
    @Published var isPlaying: Bool = false
    
    private var timer: Timer?
    private var speed: Double = 0.8
    private var bag: [BlockType] = []
    
    init() {
        // Initialize with a next piece ready to go
        refillBag()
        nextPiece = Tetromino(type: bag.removeFirst())
    }
    
    func startGame() {
        resetGame()
        AudioManager.shared.startBGM()
        spawnPiece()
        startTimer()
        isPlaying = true
        isGameOver = false
    }
    
    func resetGame() {
        grid = Array(repeating: Array(repeating: nil, count: 10), count: 20)
        score = 0
        speed = 0.8
        refillBag()
        nextPiece = Tetromino(type: bag.removeFirst())
        currentPiece = nil
        isPlaying = false
    }
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: speed, repeats: true) { _ in
            self.update()
        }
    }
    
    func update() {
        guard isPlaying, !isGameOver else { return }
        
        if !move(x: 0, y: 1) {
            lockPiece()
        }
    }
    
    func moveLeft() {
        guard isPlaying else { return }
        if move(x: -1, y: 0) {
            AudioManager.shared.playSound("move")
        }
    }
    
    func moveRight() {
        guard isPlaying else { return }
        if move(x: 1, y: 0) {
            AudioManager.shared.playSound("move")
        }
    }
    
    func rotate() {
        guard isPlaying, var piece = currentPiece else { return }
        piece.rotation += 1
        
        if isValidPosition(piece: piece) {
            currentPiece = piece
            AudioManager.shared.playSound("rotate")
        } else {
            // Wall kick attempt (simple)
            // Try shifting left
            piece.position.x -= 1
            if isValidPosition(piece: piece) {
                currentPiece = piece
                AudioManager.shared.playSound("rotate")
                return
            }
            // Try shifting right
            piece.position.x += 2 // Back to original + 1
            if isValidPosition(piece: piece) {
                currentPiece = piece
                AudioManager.shared.playSound("rotate")
                return
            }
        }
    }
    
    func hardDrop() {
        guard isPlaying, currentPiece != nil else { return }
        while move(x: 0, y: 1) {}
        lockPiece()
        AudioManager.shared.playSound("drop")
    }
    
    // Returns true if move was successful
    private func move(x: Int, y: Int) -> Bool {
        guard var piece = currentPiece else { return false }
        piece.position.x += x
        piece.position.y += y
        
        if isValidPosition(piece: piece) {
            currentPiece = piece
            return true
        }
        return false
    }
    
    private func isValidPosition(piece: Tetromino) -> Bool {
        for (x, y) in piece.absoluteBlocks() {
            if x < 0 || x >= 10 || y >= 20 {
                return false
            }
            if y >= 0 && grid[y][x] != nil {
                return false
            }
        }
        return true
    }
    
    private func lockPiece() {
        guard let piece = currentPiece else { return }
        
        // Lock the piece into the grid
        for (x, y) in piece.absoluteBlocks() {
            if y >= 0 && y < 20 && x >= 0 && x < 10 {
                grid[y][x] = piece.color
            }
        }
        
        checkLines()
        spawnPiece()
    }
    
    private func checkLines() {
        var linesToClear: [Int] = []
        
        for y in 0..<20 {
            if grid[y].allSatisfy({ $0 != nil }) {
                linesToClear.append(y)
            }
        }
        
        if !linesToClear.isEmpty {
            AudioManager.shared.playSound("clear")
            // Simple animation delay could be added here, but for now we just remove
            for y in linesToClear {
                grid.remove(at: y)
                grid.insert(Array(repeating: nil, count: 10), at: 0)
            }
            
            // Score calculation
            let points = [0, 100, 300, 500, 800]
            score += points[linesToClear.count]
            
            // Speed up
            speed = max(0.1, 0.8 - Double(score) / 5000.0)
            startTimer()
        }
    }
    
    private func spawnPiece() {
        if bag.isEmpty {
            refillBag()
        }
        
        currentPiece = nextPiece
        currentPiece?.position = (3, 0) // Start at top middle
        
        nextPiece = Tetromino(type: bag.removeFirst())
        
        // Check game over
        if !isValidPosition(piece: currentPiece!) {
            isGameOver = true
            isPlaying = false
            timer?.invalidate()
            AudioManager.shared.stopBGM()
            AudioManager.shared.playSound("gameover")
        }
    }
    
    private func refillBag() {
        bag = BlockType.allCases.shuffled()
    }
}
