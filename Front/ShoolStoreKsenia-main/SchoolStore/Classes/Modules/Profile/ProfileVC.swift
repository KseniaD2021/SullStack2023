
import UIKit
import AutoLayoutSugar
import Kingfisher

class ProfileVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.selectedItem?.title = L10n.Profile.title
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        loadData()
    }
    
    func setup() {
        photoProfile.centerX()
        nameLabel.centerX().top(to: .bottom(16), of: photoProfile)
        speciality.centerX().top(to: .bottom(0), of: nameLabel)
        toHistoryBtn.centerX().top(50)
        settingsBtnLabel.centerX().top(50)
        exitBtnLabel.centerX().top(50)

    }
    
    func setup(with profileService: ProfileService,  dataService: DataService) {
        self.profileService = profileService
        self.dataService = dataService
    }
    
    
    private func loadData() {
        profileService?.getProfile { (result: Result<Profile, Error>) in
            switch result {
            case let .success(data):
                self.profile = data
            case let .failure(error):
                self.snacker?.show(snack: error.localizedDescription.description, with: .error)
            }
        }
    }
    
    private func display() {
        guard let nameP = profile?.name,
              let surname = profile?.surname,
              let occupation = profile?.occupation
        else {
            return
        }
        
        if let preview = profile?.avatarUrl, let previewUrl = URL(string: preview) {
            let contentImageResource = ImageResource(downloadURL: previewUrl, cacheKey: preview)
            photoProfile.kf.setImage(
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
            photoProfile.image = Asset.itemPlaceholder.image
        }
        
        OrdersBtn.addSubview(toHistoryBtn)
        SettingsBtn.addSubview(settingsBtnLabel)
        ExitBtn.addSubview(exitBtnLabel)
        ProfileView.addSubview(nameLabel)
        ProfileView.addSubview(photoProfile)
        ProfileView.addSubview(speciality)
        photoProfile.layer.cornerRadius = 45
        photoProfile.clipsToBounds = true
        
        nameLabel.text = nameP + " " + surname
        speciality.text = occupation
        
        setup()
    }

    // MARK: Internal
    
    private var snacker: Snacker?
    
    private var profile: Profile? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.display()
            }
        }
    }
    private var profileService: ProfileService?
    private var dataService: DataService?

    private lazy var photoProfile: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .white
        image.height(90).width(90)

        return image
    }()
    
    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setImage(Asset.settings.image, for: .normal)
        button.layer.cornerRadius = 50
        return button
    }()
    
    private lazy var nameLabel: UILabel = {
        let txt = UILabel()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.font = .systemFont(ofSize: 24, weight: .medium)
        txt.textColor = .white
        return txt
    }()
    
    private lazy var speciality: UILabel = {
        let txt = UILabel()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.font = .systemFont(ofSize: 14, weight: .medium)
        txt.textColor = .white
        return txt
    }()
    
    private lazy var toHistoryBtn: UILabel = {
        let txt = UILabel()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.text = L10n.History.title
        txt.font = .systemFont(ofSize: 14, weight: .medium)
        txt.textColor = .white
        return txt
    }()

    private lazy var settingsBtnLabel: UILabel = {
        let txt = UILabel()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.text = L10n.EditingTitle.settings
        txt.font = .systemFont(ofSize: 14, weight: .medium)
        txt.textColor = .white
        return txt
    }()
    
    private lazy var exitBtnLabel: UILabel = {
        let txt = UILabel()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.text = L10n.Action.exitAction
        txt.font = .systemFont(ofSize: 14, weight: .medium)
        txt.textColor = .white
        return txt
    }()
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var ProfileView: ProfileView!
    @IBOutlet weak var OrdersBtn: UIButton!
    @IBOutlet weak var SettingsBtn: UIButton!
    @IBOutlet weak var ExitBtn: UIButton!
    
    
    @IBAction func logoutPressedButton(_ sender: Any) {
        let alert = UIAlertController(title: L10n.Action.exit, message: L10n.Question.exit, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: L10n.Action.exitAction, style: .default) { (sender: UIAlertAction) -> Void in
            
            UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController = VCFactory.buildAuthVC()
            self.dataService?.appState.accessToken = nil
        })
        alert.addAction(UIAlertAction(title: L10n.Action.cancel, style: .cancel){ (sender: UIAlertAction) -> Void in
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func EditProfilePressed(_ sender: Any) {
        guard let profile = self.profile else {
            return
        }
        self.navigationController?.pushViewController(VCFactory.buildEtidPage(with: profile), animated: true)
    }
    
    @IBAction func historyPage(_ sender: Any) {
        self.tabBarController?.selectedIndex = 1
    }
    
    @objc
    func specializationDidTap(_ sender: UIButton) {
        if sender.titleLabel?.text == "Другое" {
           
        } else {
            speciality.text = sender.titleLabel?.text
        }
    }
    
}

