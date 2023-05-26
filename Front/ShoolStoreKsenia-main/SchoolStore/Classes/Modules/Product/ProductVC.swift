
import AutoLayoutSugar
import Foundation
import UIKit

final class ProductVC: UIViewController {
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    // MARK: Internal
    
    var product: Product? {
        didSet {
            contentView.fillWith(product: product)
        }
    }
    
    func configure() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.pinToSuperview()
        contentView.addSubview(selectSize)
        selectSize.addSubview(size)
        selectSize.addSubview(sizeLabel)
        selectSize.addSubview(imgButton)
        contentView.pinToSuperview()
            .width(as: scrollView)
        
        scrollView
            .heightAnchor
            .constraint(lessThanOrEqualTo: contentView.heightAnchor)
            .activate()
        
        view.addSubview(payButton)
        payButton.setTitle(L10n.Product.payTitle, for: .normal)
        payButton.titleLabel?.setCharacterSpacing(1.25)
        payButton.setTitleColor(UIColor.white, for: .normal)
        payButton.backgroundColor = Asset.greenBack.color
        payButton.layer.cornerRadius = 8
        payButton.bottom(100).left(16).right(16).height(44)
        payButton.addTarget(self, action: #selector(buyProduct), for: .touchUpInside)
        
        view.addSubview(goBackButton)
        goBackButton.setTitle(L10n.Action.back, for: .normal)
        goBackButton.setTitleColor(UIColor.systemBlue, for: .normal)
        goBackButton.left(10).top(50)
        goBackButton.setImage(UIImage.init(systemName: "chevron.backward"), for: .normal)
        goBackButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        selectSize.top(455).left(16).right(16).height(54)
        sizeLabel.top(8).left(16)
        size.top(to: .bottom(0), of: sizeLabel).left(16)
        imgButton.top(22).right(22)
    }
    
    // MARK: Private
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var contentView: ProductView = {
        let contentView = ProductView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    private lazy var goBackButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var payButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private lazy var selectSize: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(action), for: .touchUpInside)
        return button
    }()
    private lazy var size: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = L10n.Product.sizeS
        return label
    }()
    
    private lazy var sizeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.text = L10n.Product.size
        return label
    }()
    
    private lazy var imgButton: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    let imageBack = UIImage(systemName: "chevron.right")
    
    @objc func buyProduct() {
        guard let product = product else {
            return
        }
        navigationController?.pushViewController(VCFactory.buildOrderVC(with: product), animated: true)
    }
    @objc
    func goBack() {
        UIApplication.shared.windows.first(where: { $0.isKeyWindow })?
            .rootViewController = VCFactory.buildTabBarVC()
    }
    
    @objc
    private func action() {
        let array = [
            L10n.Product.sizeS,
            L10n.Product.sizeM,
            L10n.Product.sizeL,
            L10n.Product.sizeXL,
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
        let vc = VCFactory.buildBottomSheetController(with: view, onEveryTapOut: nil)
        present(vc, animated: true, completion: nil)
    }
    @objc
    func specializationDidTap(_ sender: UIButton) {
        size.text = sender.titleLabel?.text
        presentedViewController?.dismiss(animated: true, completion: nil)
    }
}
extension UILabel{
    func setCharacterSpacing(_ spacing: CGFloat){
        let attributedStr = NSMutableAttributedString(string: self.text ?? "")
        attributedStr.addAttribute(NSAttributedString.Key.kern, value: spacing, range: NSMakeRange(0, attributedStr.length))
        self.attributedText = attributedStr
    }
}
