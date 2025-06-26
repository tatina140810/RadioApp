import UIKit
import MessageUI

final class ContactsViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    private let contactLabel = ContactsViewController.makeTitleLabel(text: "Наши контакты")
    private let socialMediaLabel = ContactsViewController.makeTitleLabel(text: "Наши онлайн платформы")
    
    private let emailButton = ContactsViewController.makeIconButton(image: .emailIcon, action: #selector(emailButtonTapped))
    private let emailLabel = ContactsViewController.makeInfoLabel(text: "radiotatina@gmail.com")
    
    private let phoneButton = ContactsViewController.makeIconButton(image: .phoneIcon, action: #selector(phoneButtonTapped))
    private let phoneLabel = ContactsViewController.makeInfoLabel(text: "+996 555 05 10 63")
    
    private let instagramButton = ContactsViewController.makePlatformButton(image: .instagramIcon, title: "Instagram", action: #selector(instagramButtonTapped))
    private let chromButton     = ContactsViewController.makePlatformButton(image: .chromIcon,     title: "Наш сайт", action: #selector(chromButtonTapped))
    private let okButton        = ContactsViewController.makePlatformButton(image: .okIcon,        title: "Ok", action: #selector(okButtonTapped))
    private let sharedButton    = ContactsViewController.makePlatformButton(image: .shareIcon,     title: "Поделиться", action: #selector(sharedButtonTapped))
    
    private let verticalStack = UIStackView()
    private let firstHorizontalStack = UIStackView()
    private let secondHorizontalStack = UIStackView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    private func setupLayout() {
        view.backgroundColor = .white
        
        [contactLabel, emailButton, emailLabel, phoneButton, phoneLabel, socialMediaLabel].forEach {
            view.addSubview($0)
        }
        
        [instagramButton, chromButton].forEach { firstHorizontalStack.addArrangedSubview($0) }
        [okButton, sharedButton].forEach { secondHorizontalStack.addArrangedSubview($0) }
        
        [firstHorizontalStack, secondHorizontalStack].forEach { verticalStack.addArrangedSubview($0) }
        
        verticalStack.axis = .vertical
        verticalStack.spacing = 10
        verticalStack.alignment = .center
        verticalStack.distribution = .fillEqually
        
        firstHorizontalStack.axis = .horizontal
        firstHorizontalStack.spacing = 10
        firstHorizontalStack.alignment = .center
        firstHorizontalStack.distribution = .fillEqually
        
        secondHorizontalStack.axis = .horizontal
        secondHorizontalStack.spacing = 10
        secondHorizontalStack.alignment = .center
        secondHorizontalStack.distribution = .fillEqually
        
        view.addSubview(verticalStack)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        contactLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            $0.centerX.equalToSuperview()
        }
        emailButton.snp.makeConstraints {
            $0.top.equalTo(contactLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(48)
        }
        emailLabel.snp.makeConstraints {
            $0.top.equalTo(emailButton.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        phoneButton.snp.makeConstraints {
            $0.top.equalTo(emailLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(48)
        }
        phoneLabel.snp.makeConstraints {
            $0.top.equalTo(phoneButton.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        socialMediaLabel.snp.makeConstraints {
            $0.top.equalTo(phoneLabel.snp.bottom).offset(25)
            $0.centerX.equalToSuperview()
        }
        verticalStack.snp.makeConstraints {
            $0.top.equalTo(socialMediaLabel.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(244)
        }
        firstHorizontalStack.snp.makeConstraints {
            $0.height.equalTo(75)
            $0.width.equalTo(300)
        }
        secondHorizontalStack.snp.makeConstraints {
            $0.height.equalTo(75)
            $0.width.equalTo(300)
        }
    }
    
    @objc private func emailButtonTapped() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["radiotatiina@mail.com"])
            present(mail, animated: true)
        } else if let url = URL(string: "mailto:radiotatiina@mail.com") {
            UIApplication.shared.open(url)
        }
    }
    
    @objc private func phoneButtonTapped() {
        if let url = URL(string: "tel://+996555051063"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            print("Невозможно позвонить")
        }
    }
    
    @objc private func instagramButtonTapped() {
        openURL("https://www.instagram.com/radiotatina.kg?igsh=ZjI0NG5mYTRrbjA0")
    }
    
    @objc private func chromButtonTapped() {
        openURL("https://hipolink.me/tatina_fm")
    }
    
    @objc private func okButtonTapped() {
        openURL("https://ok.ru/profile/561088619846?utm_campaign=android_share&utm_content=profile")
    }
    @objc private func sharedButtonTapped() {
        
        let text = "Слушайте радио Татина!"
        shareLogoWithText(text: text)
    }
    
    private func shareLogoWithText(text: String) {
        guard let logoImage = UIImage(named: "logo") else {
            print("⚠️ Изображение logo не найдено")
            return
        }
        
        let activityVC = UIActivityViewController(activityItems: [text, logoImage], applicationActivities: nil)
        
        if let rootVC = UIApplication.shared
            .connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow })?
            .rootViewController {
            
            var topVC = rootVC
            while let presentedVC = topVC.presentedViewController {
                topVC = presentedVC
            }
            topVC.present(activityVC, animated: true)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    private func openURL(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
    
    private static func makeTitleLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor(hex: "#000000")
        label.textAlignment = .center
        return label
    }
    
    private static func makeInfoLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = .black
        label.textAlignment = .center
        return label
    }
    
    private func makeButtonAction(selector: Selector) -> UIAction {
        return UIAction { [weak self] _ in
            self?.perform(selector)
        }
    }
    
    private static func makeIconButton(image: UIImage, action: Selector) -> UIButton {
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.addTarget(nil, action: action, for: .touchUpInside)
        return button
    }
    
    private static func makePlatformButton(image: UIImage, title: String, action: Selector) -> UIButton {
        var configuration = UIButton.Configuration.plain()
        configuration.image = image
        configuration.title = title
        configuration.baseForegroundColor = .black
        configuration.imagePadding = 8
        configuration.imagePlacement = .top
        configuration.titleAlignment = .center
        
        let button = UIButton(configuration: configuration)
        button.addTarget(nil, action: action, for: .touchUpInside)
        return button
    }
}
