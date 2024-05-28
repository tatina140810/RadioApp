//
//  AnnounceView.swift
//  RadioTatina
//
//  Created by Tatina Dzhakypbekova on 28/5/24.
//

import Foundation
import UIKit
import SnapKit

class AnnounceView: UIViewController {
    
    private lazy var titleImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(resource: .tatinaAnonce)
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    private func setupUI() {
        view.addSubview(titleImage)
        titleImage.snp.makeConstraints{make in
            make.top.equalToSuperview().offset(70)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(400)
        }
    }
}
