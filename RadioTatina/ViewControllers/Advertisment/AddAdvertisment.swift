import Foundation
import UIKit

class AddAdvertisment: UIViewController,  UITextViewDelegate {
    private var selectedCategory: AdCategory?
    private var selectedImage: UIImage?

    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Введите текст"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()

    private lazy var categoryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Выбрать категорию", for: .normal)
        button.showsMenuAsPrimaryAction = true
        button.layer.cornerRadius = 8
        button.backgroundColor = .systemGray6
        button.tintColor = .black
        button.menu = createCategoryMenu()
        return button
    }()

    private func createCategoryMenu() -> UIMenu {
        let actions: [UIAction] = [
            UIAction(title: "Недвижимость", handler: { _ in self.selectCategory(.realEstate, title: "Недвижимость") }),
            UIAction(title: "Транспорт", handler: { _ in self.selectCategory(.transport, title: "Транспорт") }),
            UIAction(title: "Услуги", handler: { _ in self.selectCategory(.services, title: "Услуги") }),
            UIAction(title: "Работа", handler: { _ in self.selectCategory(.jobs, title: "Работа") })
        ]
        return UIMenu(title: "", options: .displayInline, children: actions)
    }

    private func selectCategory(_ category: AdCategory, title: String) {
        self.selectedCategory = category
        self.categoryButton.setTitle(title, for: .normal)
    }

    private var titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите заголовок"
        textField.borderStyle = .roundedRect
        textField.font = .systemFont(ofSize: 18)
        return textField
    }()

    private var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 16)
        textView.layer.borderColor = UIColor.gray.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 8
        return textView
    }()
    private var numberLabel: UILabel = {
        let label = UILabel()
        label.text = "Укажите номер телефона для связи"
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.numberOfLines = 0
        return label
    }()

    private lazy var imageButton: UIButton = {
        let button = UIButton()
        button.setTitle("Загрузить фото", for: .normal)
        button.addTarget(self, action: #selector(imageButtonTapped), for: .touchUpInside)
        button.tintColor = .black
        button.layer.cornerRadius = 9
        button.clipsToBounds = true
        button.backgroundColor = UIColor(hex: "#2CA334")
        return button
    }()
    private var selectedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.backgroundColor = UIColor.systemGray6
        return imageView
    }()


    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Сохранить", for: .normal)
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        button.tintColor = .black
        button.layer.cornerRadius = 9
        button.clipsToBounds = true
        button.backgroundColor = UIColor(hex: "#2CA334")
        return button
    }()

    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        button.tintColor = .black
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
         tapGesture.cancelsTouchesInView = false // чтобы кнопки и другие элементы тоже реагировали
         view.addGestureRecognizer(tapGesture)
        descriptionTextView.delegate = self
    }

    private func setupUI() {
        [closeButton, titleLabel, titleTextField, categoryButton, descriptionTextView, numberLabel, imageButton, selectedImageView, saveButton].forEach {
            view.addSubview($0)
        }

        closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.size.equalTo(30)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(closeButton.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }

        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }

        categoryButton.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }

        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(categoryButton.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(100)
        }
        numberLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionTextView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            
        }
        

        imageButton.snp.makeConstraints { make in
            make.top.equalTo(numberLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(44)
            make.width.equalTo(150)
            
        }
        selectedImageView.snp.makeConstraints { make in
            make.top.equalTo(imageButton.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(200)
        }


        saveButton.snp.makeConstraints { make in
            make.top.equalTo(selectedImageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(44)
            make.width.equalTo(150)
        }
    }
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc private func imageButtonTapped() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    func compressImage(_ image: UIImage, maxSizeInBytes: Int) -> Data? {
        var compression: CGFloat = 1.0
        let minCompression: CGFloat = 0.1
        guard var imageData = image.jpegData(compressionQuality: compression) else { return nil }
        
        while imageData.count > maxSizeInBytes && compression > minCompression {
            compression -= 0.1
            if let compressedData = image.jpegData(compressionQuality: compression) {
                imageData = compressedData
            } else {
                break
            }
        }
        
        return imageData.count <= maxSizeInBytes ? imageData : nil
    }


    @objc private func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
           let currentText = textView.text ?? ""
           guard let stringRange = Range(range, in: currentText) else { return false }
    
           let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
       
           return updatedText.count <= 500
       }
    
    @objc private func saveButtonTapped() {
        guard let title = titleTextField.text, !title.isEmpty,
              let description = descriptionTextView.text, !description.isEmpty,
              let category = selectedCategory else {
            print("⚠️ Все поля обязательны")
            return
        }

        guard let selectedImage = selectedImage else {
            print("⚠️ Фото не выбрано")
            return
        }

        let maxSizeInBytes = 2 * 1024 * 1024 // 2 МБ
        guard let imageData = compressImage(selectedImage, maxSizeInBytes: maxSizeInBytes) else {
            let alert = UIAlertController(title: "Фото слишком большое", message: "Пожалуйста, выберите другое фото", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ок", style: .default))
            present(alert, animated: true)
            return
        }

        NetworkManager.shared.createAd(title: title, description: description, category: category, imageData: imageData) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    let alert = UIAlertController(
                        title: "Объявление отправлено",
                        message: "После модерации ваше объявление будет добавлено.",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: { _ in
                        self?.dismiss(animated: true)
                    }))
                    self?.present(alert, animated: true)

                case .failure(let error):
                    print("❌ Ошибка при добавлении: \(error)")
                }
            }
        }
    }


}

extension AddAdvertisment: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        if let image = info[.originalImage] as? UIImage {
            selectedImage = image
            selectedImageView.image = image
            imageButton.setTitle("Фото загружено", for: .normal)
        }
    }
}
