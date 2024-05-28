//
//  InfoView.swift
//  RadioTatina
//
//  Created by Tatina Dzhakypbekova on 28/5/24.
//

import UIKit
import SnapKit

class InfoView: UIViewController {
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.text = "НАШИ КОНТАКТЫ"
        view.font = UIFont.boldSystemFont(ofSize: 22)
        view.textColor = UIColor(hex: "310165")
        return view
    }()
    
    private lazy var emailButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.backgroundColor = UIColor(hex: "039139")
        button.layer.cornerRadius = 22
        button.setTitle("отправить e-mail", for: .normal)
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(emailButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var callButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.backgroundColor = UIColor(hex: "039139")
        button.layer.cornerRadius = 22
        button.setTitle("позвонить", for: .normal)
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(emailButtonTapped), for: .touchUpInside)
        return button
    }()
    private lazy var resourceLabel: UILabel = {
        let view = UILabel()
        view.text = "НАШИ ИНТЕРНЕТ - РЕССУРСЫ"
        view.font = UIFont.boldSystemFont(ofSize: 22)
        view.textColor = UIColor(hex: "310165")
        return view
    }()
    private lazy var conteinerStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 5
        view.alignment = .center
        
        return view
    }()
    private lazy var chromButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .chrom), for: .normal)
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(chromButtonTapped), for: .touchUpInside)
        return button
    }()
    private lazy var instagramButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .instagram), for: .normal)
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(chromButtonTapped), for: .touchUpInside)
        return button
    }()
    private lazy var okButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .ok), for: .normal)
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(chromButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var shareLabel: UILabel = {
        let view = UILabel()
        view.text = "ПОДЕЛИТЬСЯ ПРИЛОЖЕНИЕМ"
        view.font = UIFont.boldSystemFont(ofSize: 22)
        view.textColor = UIColor(hex: "310165")
        return view
    }()
    private lazy var shareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .shared), for: .normal)
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(chromButtonTapped), for: .touchUpInside)
        return button
    }()
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    private func setupUI() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints{make in
            make.top.equalToSuperview().offset(130)
            make.centerX.equalToSuperview()
        }
        view.addSubview(emailButton)
        emailButton.snp.makeConstraints{make in
            make.top.equalTo(titleLabel).offset(50)
            make.centerX.equalToSuperview()
            make.height.equalTo(44)
            make.width.equalTo(180)
        }
        view.addSubview(callButton)
        callButton.snp.makeConstraints{make in
            make.top.equalTo(emailButton).offset(70)
            make.centerX.equalToSuperview()
            make.height.equalTo(44)
            make.width.equalTo(180)
        }
        view.addSubview(resourceLabel)
        resourceLabel.snp.makeConstraints{make in
            make.top.equalTo(callButton.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
        }
        view.addSubview(conteinerStack)
        conteinerStack.snp.makeConstraints{make in
            make.top.equalTo(resourceLabel.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalToSuperview().inset(85)
        }
        conteinerStack.addSubview(chromButton)
        chromButton.snp.makeConstraints{make in
            make.top.equalTo(conteinerStack)
            make.leading.equalTo(conteinerStack).offset(20)
            make.height.equalTo(50)
            make.width.equalTo(50)
        }
        conteinerStack.addSubview(instagramButton)
        instagramButton.snp.makeConstraints{make in
            make.top.equalTo(conteinerStack)
            make.leading.equalTo(chromButton.snp.trailing).offset(20)
            make.height.equalTo(50)
            make.width.equalTo(50)
        }
        conteinerStack.addSubview(okButton)
        okButton.snp.makeConstraints{make in
            make.top.equalTo(conteinerStack)
            make.leading.equalTo(instagramButton.snp.trailing).offset(20)
            make.height.equalTo(50)
            make.width.equalTo(50)
        }
        view.addSubview(shareLabel)
        shareLabel.snp.makeConstraints{make in
            make.top.equalTo(conteinerStack.snp.bottom).offset(70)
            make.centerX.equalToSuperview()
        }
        view.addSubview(shareButton)
        shareButton.snp.makeConstraints{make in
            make.top.equalTo(shareLabel.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(50)
        }
        
    }
    @objc func emailButtonTapped(){
        
    }
    @objc func chromButtonTapped(){
        
    }

}
