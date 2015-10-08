import Foundation

enum newPosition {
    case Up, Down, Right, Left
}

class MainScene: CCNode {
    
    var snakePiece: CCNode!
    
    var swipeUp: UISwipeGestureRecognizer!
    var swipeDown: UISwipeGestureRecognizer!
    var swipeLeft: UISwipeGestureRecognizer!
    var swipeRight: UISwipeGestureRecognizer!
    
    var detectedCollision: Bool = false
    var targetPieceWasAdded: Bool = false
    let newTargetPiece = CCBReader.load("targetPiece")
    var pieceArray: [CCNode] = []
    var screenWidthPercent = CCDirector.sharedDirector().viewSize().width / 100
    var screenHeightPercent = CCDirector.sharedDirector().viewSize().height / 100
    
    var direction: newPosition = .Right
    
    func didLoadFromCCB() {
        userInteractionEnabled = true
        setupSwipeGestures()
        createInitialPiece()
        spawnTargetPiece()
        schedule("makeSnakeMove", interval: 0.09)
    }
    
    
    func createInitialPiece() {
        let snakePiece = CCBReader.load("Piece")
        snakePiece.position = ccp(160, 300)
        pieceArray.append(snakePiece)
        addChild(snakePiece)
    }
    
    func makeSnakeMove() {
        let lastPiece: CCNode = pieceArray[pieceArray.count - 1]
        let firstPiece: CCNode = pieceArray[0]
        let firstPiecesPosition = firstPiece.position
        let newPosition = newXandYalues(firstPiecesPosition)
        let newPiece = CCBReader.load("Piece") as! Piece
        newPiece.position = newPosition
        
        removeChild(lastPiece)
        pieceArray.removeAtIndex(pieceArray.indexOf(lastPiece)!)
        addChild(newPiece)
        pieceArray.insert(newPiece, atIndex: 0)
        
    }
    
    func newXandYalues(point: CGPoint) -> CGPoint {
        var newPosition: CGPoint!
        
        switch direction {
        case .Up:
            newPosition = ccp(point.x, point.y + 15)
        case .Down:
            newPosition = ccp(point.x, point.y - 15)
        case .Left:
            newPosition = ccp(point.x - 15, point.y)
        case .Right:
            newPosition = ccp(point.x + 15, point.y)
        }
        return newPosition
    }
    
    func setupSwipeGestures() {
        swipeUp = UISwipeGestureRecognizer(target: self, action: "up")
        swipeUp.direction = .Up
        CCDirector.sharedDirector().view.addGestureRecognizer(swipeUp)
        
        swipeDown = UISwipeGestureRecognizer(target: self, action: "down")
        swipeDown.direction = .Down
        CCDirector.sharedDirector().view.addGestureRecognizer(swipeDown)
        
        swipeLeft = UISwipeGestureRecognizer(target: self, action: "left")
        swipeLeft.direction = .Left
        CCDirector.sharedDirector().view.addGestureRecognizer(swipeLeft)
        
        swipeRight = UISwipeGestureRecognizer(target: self, action: "right")
        swipeRight.direction = .Right
        CCDirector.sharedDirector().view.addGestureRecognizer(swipeRight)
    }
    func up() {
        if direction != .Down {
            direction = .Up
        }
    }
    func down() {
        if direction != .Up {
            direction = .Down
        }
    }
    func left() {
        if direction != .Right {
            direction = .Left
        }
    }
    func right() {
        if direction != .Left {
            direction = .Right
        }
    }
    
    func spawnTargetPiece() {
        let randomX = arc4random_uniform(UInt32(CCDirector.sharedDirector().viewSize().width))
        let randomY = arc4random_uniform(UInt32(CCDirector.sharedDirector().viewSize().height))
        
        newTargetPiece.position = ccp(CGFloat(randomX), CGFloat(randomY))
        if !targetPieceWasAdded {
            addChild(newTargetPiece)
            targetPieceWasAdded = true
        }
        detectedCollision = false
    }
    
    func addSnakePiece() {
        let newSnakePiece = CCBReader.load("Piece")
        let frontPiece = pieceArray[0]
        newSnakePiece.position = newXandYalues(frontPiece.position)
        pieceArray.insert(newSnakePiece, atIndex: 0)
        addChild(newSnakePiece)
        detectedCollision = false
    }
    func checkForCollisionWithTarget() {
        if CGRectIntersectsRect(pieceArray[0].boundingBox(), newTargetPiece.boundingBox()) {
            if !detectedCollision {
                detectedCollision = true
                spawnTargetPiece()
                addSnakePiece()
            }
        }
    }
    func checkForGameover() {
        for piece in pieceArray {
            if piece != pieceArray[0] {
                if CGRectIntersectsRect(piece.boundingBox(), pieceArray[0].boundingBox()) {
                    CCDirector.sharedDirector().presentScene(CCBReader.loadAsScene("MainScene"))
                }
            }
        }
    }
    override func update(delta: CCTime) {
        checkForCollisionWithTarget()
        checkForGameover()
    }
    
}
