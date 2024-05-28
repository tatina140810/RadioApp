import UIKit

class ButtonSettins: UILabel {
    
    func buttonMaker(text: String? = nil,
                     image: UIImage? = nil,
                         font: UIFont = .boldSystemFont(ofSize: 16),
                         tintColor: UIColor = .black,
                         textAlignment: NSTextAlignment = .left,
                         backgroundColor: UIColor = UIColor(hex: "FFFFFF"),
                         cornerRadius: CGFloat = 30
        ) -> UIButton {
            let button = UIButton()
            button.setTitle(text, for: .normal)
            button.setImage(image, for: .normal)
            button.titleLabel?.font = font
            button.tintColor = tintColor
            button.titleLabel?.textAlignment = textAlignment
            button.backgroundColor = backgroundColor
            button.layer.cornerRadius = cornerRadius
            return button
        }
    }
