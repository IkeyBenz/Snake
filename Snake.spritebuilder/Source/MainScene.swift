import Foundation

enum newPosition {
    case Up, Down, Right, Left
}

class MainScene: CCNode {
    
    var pieceArray: [Piece] = []
    var screenWidthPercent = CCDirector.sharedDirector().viewSize().width / 100
    var screenHeightPercent = CCDirector.sharedDirector().viewSize().height / 100
    
    var direction: newPosition = .Right
    
    func didLoadFromCCB() {
        println("Loaded")
        createInitialPiece()
        schedule("makeSnakeMove", interval: 0.1)
    }
    
    func createInitialPiece() {
        let firstSnake = CCBReader.load("Piece") as! Piece
        firstSnake.position = ccp(160, 300)
        pieceArray.append(firstSnake)
        addChild(firstSnake)
    }
    
    func makeSnakeMove() {
        var lastPiece: Piece = pieceArray[pieceArray.count - 1]
        var firstPiece: Piece = pieceArray[0]
        var firstPiecesPosition = firstPiece.position
        var newPosition = newXandYalues(firstPiecesPosition)
        var newPiece = CCBReader.load("Piece") as! Piece
        newPiece.position = newPosition
        
        removeChild(lastPiece)
        pieceArray.removeAtIndex(pieceArray.count - 1)
        addChild(newPiece)
        pieceArray.append(newPiece)
        
    }
    
    func newXandYalues(point: CGPoint) -> CGPoint {
        var newPosition: CGPoint!
        
        switch direction {
        case .Up:
            newPosition = ccp(point.x, point.y + screenHeightPercent * 2.5)
        case .Down:
            newPosition = ccp(point.x, point.y - screenHeightPercent * 2.5)
        case .Left:
            newPosition = ccp(point.x - screenWidthPercent * 5, point.y)
        case .Right:
            newPosition = ccp(point.x + screenWidthPercent * 5, point.y)
        }
        return newPosition
    }
    
    func setupSwipeGestures() {
        
        
    }
    
}
