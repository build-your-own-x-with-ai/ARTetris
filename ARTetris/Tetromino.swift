
import SwiftUI

enum BlockType: CaseIterable {
    case I, J, L, O, S, T, Z
}

struct Tetromino {
    let type: BlockType
    var rotation: Int = 0
    var position: (x: Int, y: Int) = (0, 0)
    
    var color: Color {
        switch type {
        case .I: return .cyan
        case .J: return .blue
        case .L: return .orange
        case .O: return .yellow
        case .S: return .green
        case .T: return .purple
        case .Z: return .red
        }
    }
    
    var blocks: [(Int, Int)] {
        let shapes: [BlockType: [[(Int, Int)]]] = [
            .I: [
                [(0, 1), (1, 1), (2, 1), (3, 1)],
                [(2, 0), (2, 1), (2, 2), (2, 3)],
                [(0, 2), (1, 2), (2, 2), (3, 2)],
                [(1, 0), (1, 1), (1, 2), (1, 3)]
            ],
            .J: [
                [(0, 0), (0, 1), (1, 1), (2, 1)],
                [(1, 0), (2, 0), (1, 1), (1, 2)],
                [(0, 1), (1, 1), (2, 1), (2, 2)],
                [(1, 0), (1, 1), (0, 2), (1, 2)]
            ],
            .L: [
                [(2, 0), (0, 1), (1, 1), (2, 1)],
                [(1, 0), (1, 1), (1, 2), (2, 2)],
                [(0, 1), (1, 1), (2, 1), (0, 2)],
                [(0, 0), (1, 0), (1, 1), (1, 2)]
            ],
            .O: [
                [(1, 0), (2, 0), (1, 1), (2, 1)],
                [(1, 0), (2, 0), (1, 1), (2, 1)],
                [(1, 0), (2, 0), (1, 1), (2, 1)],
                [(1, 0), (2, 0), (1, 1), (2, 1)]
            ],
            .S: [
                [(1, 0), (2, 0), (0, 1), (1, 1)],
                [(1, 0), (1, 1), (2, 1), (2, 2)],
                [(1, 1), (2, 1), (0, 2), (1, 2)],
                [(0, 0), (0, 1), (1, 1), (1, 2)]
            ],
            .T: [
                [(1, 0), (0, 1), (1, 1), (2, 1)],
                [(1, 0), (1, 1), (2, 1), (1, 2)], // Wait, standard T rotation
                // Let's use a simpler relative offset system or just hardcode correct rotations
                // Standard T:
                // . T .
                // T T T
                // (1,0), (0,1), (1,1), (2,1)
                
                // Rot 1 (Right):
                // . T .
                // . T T
                // . T .
                [(1, 0), (1, 1), (2, 1), (1, 2)],
                
                // Rot 2 (Down):
                // . . .
                // T T T
                // . T .
                [(0, 1), (1, 1), (2, 1), (1, 2)],
                
                // Rot 3 (Left):
                // . T .
                // T T .
                // . T .
                [(1, 0), (0, 1), (1, 1), (1, 2)]
            ],
            .Z: [
                [(0, 0), (1, 0), (1, 1), (2, 1)],
                [(2, 0), (1, 1), (2, 1), (1, 2)],
                [(0, 1), (1, 1), (1, 2), (2, 2)],
                [(1, 0), (0, 1), (1, 1), (0, 2)]
            ]
        ]
        
        let rotations = shapes[type] ?? []
        return rotations[rotation % rotations.count]
    }
    
    // Get absolute coordinates on the board
    func absoluteBlocks() -> [(Int, Int)] {
        return blocks.map { ($0.0 + position.x, $0.1 + position.y) }
    }
}
