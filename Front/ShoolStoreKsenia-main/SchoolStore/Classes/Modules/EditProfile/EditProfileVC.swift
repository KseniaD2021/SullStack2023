
import AutoLayoutSugar
import Foundation
import UIKit
import Kingfisher

class EditProfileVC: UIViewController, UIGestureRecognizerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = L10n.EditingTitle.title
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.pinToSuperview()
        contentView.pinToSuperview()
            .width(as: scrollView)
        scrollView
            .heightAnchor
            .constraint(lessThanOrEqualTo: contentView.heightAnchor)
            .activate()
        
        editButton.isEnabled = false
        editButton.alpha = 0.6
        view.addSubview(editButton)
        
        editButton.bottom(100).left(16).right(16).height(44)
        editButton.layer.cornerRadius = 8
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(surnameLabel)
        contentView.addSubview(occupationLabel)
        contentView.addSubview(anotherOccupation)
        
        setup()
        
        let endTabRecognizer = UITapGestureRecognizer(target: self, action: #selector(endEdditing))
        endTabRecognizer.delegate = self
        endTabRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(endTabRecognizer)
        
        
    }
    
    @objc func endEdditing(){
        getEditInfo()
        view.endEditing(true)
    }
    
    var profile: Profile? {
        didSet {
            nameLabel.textField.text = profile?.name
            nameLabel.titleLabel.isHidden = false
            
            surnameLabel.textField.text = profile?.surname
            surnameLabel.titleLabel.isHidden = false
            
            occupationLabel.textField.text = profile?.occupation
            occupationLabel.titleLabel.isHidden = false
            
            if let preview = profile?.avatarUrl, let previewUrl = URL(string: preview) {
                let contentImageResource = ImageResource(downloadURL: previewUrl, cacheKey: preview)
                imageView.kf.setImage(
                    with: contentImageResource,
                    placeholder: Asset.itemPlaceholder.image,
                    options: [
                        .transition(.fade(0.2)),
                        .forceTransition,
                        .cacheOriginalImage,
                        .keepCurrentImageWhileLoading,
                    ]
                )
            } else {
                imageView.image = Asset.itemPlaceholder.image
            }
        }
    }
   
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        return contentView
    }()
    
    private lazy var goBackButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.setTitle(L10n.EditingTitle.action, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Asset.textSecondary.color
        button.addTarget(self, action: #selector(editProfile), for: .touchUpInside)
        return button
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = Asset.imagePlaceholder.image
        imageView.height(90).width(90)
        imageView.backgroundColor = .systemGray5
        imageView.layer.cornerRadius = 45
        return imageView
    }()
    
    
    private lazy var nameLabel: InputField = {
        let txtField = InputField()
        txtField.title = L10n.EditingTitle.name
        txtField.layer.cornerRadius = 12
        
        txtField.translatesAutoresizingMaskIntoConstraints = false
        return txtField
    }()
    private lazy var surnameLabel: InputField = {
        let txtField = InputField()
        txtField.title = L10n.EditingTitle.surname
        txtField.layer.cornerRadius = 12
        txtField.translatesAutoresizingMaskIntoConstraints = false
        return txtField
    }()
    
    private lazy var occupationLabel: InputField = {
        let textField = InputField()
        textField.title = L10n.EditingTitle.occupation
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 10
        textField.textField.addTarget(self, action: #selector(test), for: .editingDidBegin)
        return textField
    }()
    private lazy var anotherOccupation: InputField = {
        let textField = InputField()
        textField.title = L10n.EditingTitle.anotherOccupation
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isHidden = true
        
        return textField
    }()
    
    private func setup() {
        imageView.top(16).centerX()
        nameLabel.top(to: .bottom(32), of: imageView).left(16).right(16)
        surnameLabel.top(to: .bottom(32), of: nameLabel).left(16).right(16)
        occupationLabel.top(to: .bottom(32), of: surnameLabel).left(16).right(16)
        anotherOccupation.top(to: .bottom(32), of: occupationLabel).left(16).right(16)
        
        
        let iconImage = UIImageView()
        let icon = UIImage(systemName: "chevron.right")
        
        iconImage.image = icon
        
        occupationLabel.textField.rightViewMode = .always
        occupationLabel.textField.rightView = iconImage
        
        
        
    }
    @objc
    func test() {
        let array = [
            L10n.Occupation.iosDeveloper,
            L10n.Occupation.androidDeveloper,
            L10n.Occupation.tester,
            L10n.Occupation.another,
        ]
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .leading
        view.translatesAutoresizingMaskIntoConstraints = false
        array.forEach { specialization in
            let button = UIButton()
            button.height(44)
            button.setTitleColor(.blue, for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle(specialization, for: .normal)
            button.addTarget(self, action: #selector(specializationDidTap), for: .touchUpInside)
            
            view.addArrangedSubview(button)
        }
        let vc = VCFactory.buildBottomSheetController(
            with: view,
            onEveryTapOut: nil
        )
        present(vc, animated: true, completion: nil)
    }
    
    @objc
    func specializationDidTap(_ sender: UIButton) {
        if sender.titleLabel?.text == L10n.Occupation.another {
            anotherOccupation.isHidden = false
        }
        
        occupationLabel.textField.text = sender.titleLabel?.text
        presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
    var profileService: ProfileService?
    private var snacker: Snacker?

    func setup(with profileService: ProfileService, _ snacker: Snacker){
        self.profileService = profileService
        self.snacker = snacker
    }
    
    @objc
    func editProfile(){
        if anotherOccupation.isHidden == true{
            guard let name = nameLabel.text,
                  let surname = surnameLabel.text,
                  let ocсupation = occupationLabel.text,
                  let avatar = profile?.avatarUrl else { return }
            sentEdit(name: name, surname: surname, avatar: avatar, ocсupation: ocсupation)
        } else {
            guard let name = nameLabel.text,
                  let surname = surnameLabel.text,
                  let ocсupation = anotherOccupation.text,
                  let avatar = profile?.avatarUrl else { return }
//            sentEdit(name: name, surname: surname, avatar: avatar, ocсupation: ocсupation)
        }
    }
    @objc
    func getEditInfo(){
        if anotherOccupation.isHidden == false {
            guard let occupation = anotherOccupation.text else { return }
            let flag = 1
            checkData(occupation: occupation, flag: flag)
        } else {
            guard let occupation = occupationLabel.text else { return }
            let flag = 0
            checkData(occupation: occupation, flag: flag)
        }
    }
    func checkData(occupation: String, flag: Int){
        guard let name = nameLabel.text, let surname = surnameLabel.text else { return }
        if name.isEmpty {
            nameLabel.error = L10n.Common.emptyField
        }
        if surname.isEmpty {
            surnameLabel.error = L10n.Common.emptyField
        }
        if anotherOccupation.text == profile?.occupation{
            anotherOccupation.error = L10n.EditingTitle.double
        }
        if occupation.isEmpty {
            if flag == 1{
                anotherOccupation.error = L10n.Common.emptyField
            } else {
                occupationLabel.error = L10n.Common.emptyField
            }
        }
        
        if ((!name.isEmpty && !surname.isEmpty && !occupation.isEmpty && !occupation.isEmpty ) && (
            name != profile?.name ||
            surname != profile?.surname ||
            occupation != profile?.occupation &&
            anotherOccupation.text != profile?.occupation
        ))
        {
            editButton.alpha = 1
            editButton.backgroundColor = Asset.greenBack.color
            editButton.isEnabled = true
        }
    }
    
    func sentEdit(name: String, surname: String, avatar: String, ocсupation: String){
        profileService?.userChange(
            profile: .init(
                id: profile?.id ?? 0,
                authId: profile?.authId ?? 0,
                name: name,
                surname: surname,
                occupation: ocсupation,
                avatarUrl: profile?.avatarUrl ?? ""
            ),
            completion: { (result: Result<Void, Error>) in
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                case let .failure(error):
                    self.snacker?.show(snack: error.localizedDescription, with: .error)
                    DispatchQueue.main.async {
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                }
            }
        )
    }
}

