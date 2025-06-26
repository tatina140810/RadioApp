//
//  NewsCell.swift
//  RadioTatina
//
//  Created by Tatina Dzhakypbekova on 22/6/2025.
//

import UIKit
import SnapKit

class NewsCell: UICollectionViewCell {
    
    static let identifier = "NewsCell"
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 6
        return label
    }()
    
    let adImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 6
        image.clipsToBounds = true
        return image
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(adImageView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(5)
            make.trailing.equalTo(adImageView.snp.leading).offset(-10)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.equalTo(titleLabel)
            make.trailing.equalTo(titleLabel)
        }
        
        adImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.width.equalTo(110)
            make.height.equalTo(110)
        }
    }
    func configure(title: String, subtitle: String, imageURL: String?) {
        titleLabel.text = title
        descriptionLabel.text = subtitle
        if let urlString = imageURL, let url = URL(string: urlString) {
            // Загрузка вручную (если нет SDWebImage)
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data {
                    DispatchQueue.main.async {
                        self.adImageView.image = UIImage(data: data)
                    }
                }
            }.resume()
        } else {
            adImageView.image = UIImage(resource: .frame14) // Заглушка по умолчанию
        }
    }

}
