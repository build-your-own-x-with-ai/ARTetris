
import SwiftUI
import RealityKit

struct ContentView : View {
    @StateObject private var game = TetrisGame()
    
    // Board configuration
    let blockSize: Float = 0.03
    let spacing: Float = 0.002
    
    var body: some View {
        ZStack {
            // AR View
            RealityView { content in
                // Create camera anchor (fixed to the camera/device)
                let anchor = AnchorEntity(.camera)
                
                // Create a container for the board
                let boardNode = Entity()
                // Position relative to head:
                // X: Centered (-5 blocks width offset)
                // Y: Slightly down (-0.4m) so it's not blocking eyes
                // Z: 0.8 meters in front (-0.8m)
                boardNode.position = [-(blockSize + spacing) * 5, -0.4, -0.8] 
                anchor.addChild(boardNode)
                
                // --- VISUAL BOUNDARY (FRAME) ---
                // Create a semi-transparent box to show where the game is
                let boardWidth = (blockSize + spacing) * 10
                let boardHeight = (blockSize + spacing) * 20
                let frameMesh = MeshResource.generateBox(width: boardWidth, height: boardHeight, depth: blockSize)
                var frameMaterial = SimpleMaterial(color: .blue.withAlphaComponent(0.2), isMetallic: false)
                frameMaterial.color = .init(tint: .blue.withAlphaComponent(0.2), texture: nil)
                
                let frameEntity = ModelEntity(mesh: frameMesh, materials: [frameMaterial])
                // Position center of the box
                frameEntity.position = [boardWidth / 2 - (blockSize/2), boardHeight / 2, 0]
                boardNode.addChild(frameEntity)
                
                // Pre-create 200 blocks (10x20)
                let mesh = MeshResource.generateBox(size: blockSize, cornerRadius: blockSize * 0.1)
                let material = SimpleMaterial(color: .gray, isMetallic: false)
                
                for y in 0..<20 {
                    for x in 0..<10 {
                        let block = ModelEntity(mesh: mesh, materials: [material])
                        block.name = "block_\(x)_\(y)" // Name for easier lookup
                        block.position = [
                            Float(x) * (blockSize + spacing),
                            Float(y) * (blockSize + spacing) + (blockSize / 2),
                            0
                        ]
                        block.isEnabled = false // Hidden by default
                        boardNode.addChild(block)
                    }
                }
                
                content.camera = .spatialTracking
                content.add(anchor)
                
            } update: { content in
                guard let anchor = content.entities.first(where: { $0 is AnchorEntity }),
                      let boardNode = anchor.children.first else { return }
                
                // Helper to find block by coordinates
                func updateBlock(x: Int, y: Int, color: Color?, visible: Bool) {
                    // AR Y is inverted relative to Grid Y visually?
                    // Game Grid: (0,0) is top-left usually in 2D arrays, but here...
                    // In TetrisGame:
                    // grid[0] is top? or bottom?
                    // Usually spawn at top.
                    // Let's assume grid[0] is ROW 0.
                    // If we spawn at (3,0), and that's top, then 0 is top.
                    // In AR: Y increases upwards. 0 is floor.
                    // So Game Y=0 (Top) -> AR Y=19 (Top)
                    // Game Y=19 (Bottom) -> AR Y=0 (Floor)
                    
                    // We named blocks block_x_visualY
                    // So we want block_x_(19-y)
                    
                    let visualY = 19 - y
                    if let block = boardNode.findEntity(named: "block_\(x)_\(visualY)") as? ModelEntity {
                        block.isEnabled = visible
                        if let c = color, visible {
                            block.model?.materials = [SimpleMaterial(color: UIColor(c), isMetallic: false)]
                        }
                    }
                }
                
                // 1. Clear all first (or just update all)
                // We iterate the Game Grid
                for y in 0..<20 {
                    for x in 0..<10 {
                        if let color = game.grid[y][x] {
                            updateBlock(x: x, y: y, color: color, visible: true)
                        } else {
                            // If it's not in the grid, it might be the current piece.
                            // simpler: Set to invisible, then override with current piece
                            updateBlock(x: x, y: y, color: nil, visible: false)
                        }
                    }
                }
                
                // 2. Draw Current Piece
                if let piece = game.currentPiece {
                    for (px, py) in piece.absoluteBlocks() {
                         updateBlock(x: px, y: py, color: piece.color, visible: true)
                    }
                }
            }
            
            // UI Overlay
            VStack {
                // Top HUD
                HStack {
                    Spacer()
                    VStack {
                        Text("Score: \(game.score)")
                            .font(.title)
                            .bold()
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(10)
                        
                        if let next = game.nextPiece {
                            VStack {
                                Text("Next")
                                    .font(.caption)
                                NextPieceView(piece: next)
                                    .frame(width: 50, height: 50)
                            }
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(10)
                        }
                    }
                    .padding()
                }
                
                Spacer()
                
                // Start Button (Centered when not playing)
                if !game.isPlaying {
                    Button(action: {
                        game.startGame()
                    }) {
                        Text(game.isGameOver ? "Game Over\nRestart" : "Start Game")
                            .font(.largeTitle)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(15)
                            .shadow(radius: 10)
                    }
                    .padding()
                }
                
                // Controls (Bottom)
                if game.isPlaying {
                    HStack(spacing: 20) {
                        // Left
                        Button(action: { game.moveLeft() }) {
                            Image(systemName: "arrow.left.circle.fill")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .foregroundColor(.white)
                        }
                        
                        // Down (Drop)
                        Button(action: { game.hardDrop() }) {
                            Image(systemName: "arrow.down.circle.fill")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .foregroundColor(.white)
                        }
                        
                        // Rotate
                        Button(action: { game.rotate() }) {
                            Image(systemName: "arrow.triangle.2.circlepath.circle.fill")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .foregroundColor(.yellow)
                        }
                        
                        // Right
                        Button(action: { game.moveRight() }) {
                            Image(systemName: "arrow.right.circle.fill")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.bottom, 30)
                    .background(Color.black.opacity(0.3).cornerRadius(20))
                }
            }
            .padding()
        }
        .edgesIgnoringSafeArea(.all)
    }
}

// Helper View for Next Piece Preview
struct NextPieceView: View {
    let piece: Tetromino
    
    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size.width / 4
            ForEach(0..<4) { i in
                let block = piece.blocks[i]
                Rectangle()
                    .fill(piece.color)
                    .frame(width: size - 2, height: size - 2)
                    .position(
                        x: CGFloat(block.0) * size + size/2,
                        y: CGFloat(block.1) * size + size/2
                    )
            }
        }
    }
}

#Preview {
    ContentView()
}
