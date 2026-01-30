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
                                let tile = viewModel.tiles[index]
                                GameTileView(
                                    color: tile.color,
                                    shape: tile.shape,  // FIXED: Pass actual shape from tile
                                    size: tileSize,
                                    isWrong: viewModel.wrongTileIndex == index,
                                    shapeMode: viewModel.shapeMode
                                )
                                .onTapGesture {
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

#Preview {
    ZStack {
        GalaxyBackgroundView()
        GameGridView(viewModel: GameViewModel())
    }
}
