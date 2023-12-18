import EnumInitializer

@EnumInitializer
enum Direction {
    case north
    case south
    case east
    case west
    
    var oppositeDirection: Direction {
        switch self {
        case .north: 
            return .south
        case .south: 
            return .north
        case .east:
            return .west
        case .west:
            return .east
        }
    }
}

