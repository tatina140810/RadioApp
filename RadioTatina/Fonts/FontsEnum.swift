import UIKit

enum Fonts: String {
    case bold = "Satoshi-Bold"
    case medium = "Satoshi-Medium"
    case regular = "Satoshi-Regular"
    
    func size(_ size: CGFloat) -> UIFont {
        if let font = UIFont(name: rawValue, size: size) {
            return font
        } else {
            return UIFont.systemFont(ofSize: size)
        }
    }
}
