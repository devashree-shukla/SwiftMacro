import ReuseIdentifier

@ReuseIdentifier
class CarouselCollectionViewCell {}

let reuseId = CarouselCollectionViewCell.reuseIdentifier


enum TestMacro {
    case one
    case two
}

//let reuseId = TestMacro.reuseIdentifier : output - Type 'TestMacro' has no member 'reuseIdentifier'
