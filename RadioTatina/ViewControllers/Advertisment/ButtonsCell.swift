import UIKit
import SnapKit

class ButtonsCell: UICollectionViewCell {
    static let identifier = "ButtonsCell"
    
    private let button: UIButton = {
        let button = UIButton()
        button.isUserInteractionEnabled = false 
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.backgroundColor = UIColor(hex: "#2CA334")
        button.layer.cornerRadius = 6
        button.clipsToBounds = true
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(button)
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with category: AdCategory, isSelected: Bool) {
        button.setTitle(category.displayName, for: .normal)
        button.backgroundColor = isSelected ? UIColor.systemGreen : UIColor.systemGray5
        button.setTitleColor(isSelected ? .white : .black, for: .normal) // 💡 ВАЖНО
    }


}
