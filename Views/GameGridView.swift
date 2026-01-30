import SwiftUI

struct GameGridView: View {
    @ObservedObject var viewModel: GameViewModel
    
    var body: some View {
        GeometryReader { geometry in
            let gridSize = viewModel.mode.gridSize
            let spacing: CGFloat = gridSize >= 5 ? 6 : 8
            let totalSpacing = spacing * CGFloat(gridSize - 1)
            let availableWidth = min(geometry.size.width, geometry.size.height) - 20
            let tileSize = (availableWidth - totalSpacing) / CGFloat(gridSize)
            
            VStack(spacing: spacing) {
                ForEach(0..<gridSize, id: \.self) { row in
                    HStack(spacing: spacing) {
                        ForEach(0..<gridSize, id: \.self) { col in
                            let index = row * gridSize + col
                            if index < viewModel.tiles.count {
                                let tileValue = viewModel.tiles[index]
                                let tileColor = viewModel.colors[tileValue]
                                
                                Circle()
                                    .fill(tileColor)
                                    .frame(width: tileSize * 0.8, height: tileSize * 0.8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(viewModel.wrongTileIndex == index ? Color.red.opacity(0.3) : Color.white.opacity(0.08))
                                            .frame(width: tileSize, height: tileSize)
                                    )
                                    .onTapGesture {
                                        print("👆 Grid tap at index \(index)")
                                        viewModel.tileTapped(at: index)
                                    }
                            }
                        }
                    }
                }
            }
            .frame(width: availableWidth, height: availableWidth)
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }
    }
}
