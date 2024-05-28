
import UIKit

class CustomNavigationBarInMuzicPage: UIView {
    
    private lazy var backButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        view.tintColor = .black
        //view.addTarget(self, action: #selector(backBtnTapped), for: .touchUpInside)
        return view
    }()
   
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.text = "Now playing"
        view.font = UIFont(name: "Satoshi-Bold", size:18)
        view.textColor = .black
        view.textAlignment = .center
        return view
    }()
    
    private lazy var menuButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "slider.horizontal.3"), for: .normal)
        view.tintColor = .black
        //view.addTarget(self, action: #selector(backBtnTapped), for: .touchUpInside)
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupUI()
    }
    
    private func  setupUI() {
        
        addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(33)
            make.width.equalTo(33)
        }
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
           
           
        }
        addSubview(menuButton)
        menuButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(33)
            make.width.equalTo(33)
        }
        
    }
}
