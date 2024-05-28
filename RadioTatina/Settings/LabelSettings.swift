import UIKit

class LabelSettins: UILabel {
    
    func makerLabel(text: String, font: UIFont = .boldSystemFont(ofSize: 16),
                    textColor: UIColor = .black,
                    textAligmat: NSTextAlignment = .left,
                    numberOfLines: Int = 0
                    ) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = font
        label.textColor = textColor
        label.textAlignment = textAligmat
        label.numberOfLines = numberOfLines
        
        return label
    }
}
