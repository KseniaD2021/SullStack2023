
import AutoLayoutSugar
import Kingfisher
import UIKit

final class ProductView: UIView {
    // MARK: Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    // MARK: Internal

    func fillWith(product: Product?) {
        guard let product = product else {
            return
        }
        print("id prView:  ", product.id, "URL prView: ", product.preview)

        if let previewUrl = URL(string: product.preview) {
            let contentImageResource = ImageResource(downloadURL: previewUrl, cacheKey: product.preview)
            mainImageView.kf.setImage(
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
            mainImageView.image = Asset.itemPlaceholder.image
        }
        product.images?.forEach { preview in
            let buton = UIButton()
            buton.translatesAutoresizingMaskIntoConstraints = false

            let previewView: UIImageView = {
                let imageView = UIImageView()
                imageView.translatesAutoresizingMaskIntoConstraints = false
                return imageView
            }()
            buton.addSubview(previewView)
            buton.height(32).width(32)

            previewView.pinToSuperview()

            if let previewUrl = URL(string: preview) {
                let contentImageResource = ImageResource(
                    downloadURL: previewUrl,
                    cacheKey: preview
                )
                previewView.kf.setImage(
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
                previewView.image = Asset.itemPlaceholder.image
            }
            buton.addTarget(self, action: #selector(previewDidTap), for: .touchUpInside)
            previewsStackView.addArrangedSubview(buton)
        }
        
        titleLabel.text = product.title
        priceLabel.text = NumberFormatter.rubString(from: product.price)
        departmentLabel.text = product.department
        descriptionLabel.text = product.description
        detailsLabel.text = product.details?.first

    }

    // MARK: Private

    private let textPrimaryColor: UIColor = Asset.textPrimary.color
    private let textSecondaryColor: UIColor = Asset.textSecondary.color
    
    private lazy var mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private lazy var previewsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        return stackView
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var badgeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .white
        
        return label
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var departmentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var sizeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var detailsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var badgeLabelView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var img: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()

    @objc
    private func previewDidTap(_ sender: UIButton) {
        guard let imageView = sender.subviews.first(where: { $0 is UIImageView }) as? UIImageView,
              let image = imageView.image
        else {
            return
        }
        mainImageView.image = image
    }

    private func setup() {
        addSubview(mainImageView)
        addSubview(scrollView)
        addSubview(priceLabel)
        addSubview(badgeLabelView)
        badgeLabelView.addSubview(badgeLabel)
        addSubview(titleLabel)
        addSubview(departmentLabel)
        addSubview(sizeLabel)
        addSubview(descriptionLabel)
        addSubview(separatorView)
        addSubview(detailsLabel)
        sizeLabel.addSubview(img)
        
        let icon = UIImage(systemName: "chevron.right")
        img.image = icon
        
        img.centerY().right(25)
        
        mainImageView.image = Asset.imagePlaceholder.image
        mainImageView.top().centerX().width(284).height(284)

        scrollView.addSubview(previewsStackView)

        scrollView
            .top(to: .bottom(20), of: mainImageView)
            .height(32)

        scrollView.widthAnchor
            .constraint(lessThanOrEqualTo: previewsStackView.widthAnchor)
            .priority(999)
            .activate()

        scrollView.leadingAnchor
            .constraint(equalTo: leadingAnchor, constant: 16)
            .activate()

        scrollView.trailingAnchor
            .constraint(equalTo: trailingAnchor, constant: -16)
            .activate()

        previewsStackView.top().bottom().centerX().height(as: scrollView)


        priceLabel.textColor = textPrimaryColor
        priceLabel.font = UIFont(name: "Roboto-Medium", size: 24)
        priceLabel.top(to: .bottom(20), of: scrollView).left(16)

        badgeLabel.text = L10n.Product.badge
        badgeLabel.centerX().centerY()
        
        badgeLabelView.backgroundColor = .systemGreen
        badgeLabelView.layer.masksToBounds = true
        badgeLabelView.layer.cornerRadius = 8
        badgeLabelView.right(16).centerY(0, to: priceLabel).width(99).height(30)
        badgeLabelView.layer.cornerRadius = 15


        titleLabel.textColor = textPrimaryColor
        titleLabel.font = UIFont(name: "Roboto-Regular", size: 20)
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 0
        titleLabel.top(to: .bottom(16), of: priceLabel).left(16).right(16)


        departmentLabel.textColor = textSecondaryColor
        departmentLabel.font = UIFont(name: "Roboto-Medium", size: 14)
        departmentLabel.top(to: .bottom(4), of: titleLabel).left(16)

        sizeLabel.backgroundColor = textSecondaryColor
        sizeLabel.alpha = 0.3
        sizeLabel.top(to: .bottom(16), of: departmentLabel).left(16).right(16).height(54)

        
        descriptionLabel.textColor = textPrimaryColor
        descriptionLabel.font = UIFont(name: "Roboto-Regular", size: 14)
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.numberOfLines = 0
        descriptionLabel.top(to: .bottom(16), of: sizeLabel).left(16).right(16)

        separatorView.backgroundColor = Asset.separator.color
        separatorView.top(to: .bottom(16), of: descriptionLabel).left(16).right(16).height(1)

        detailsLabel.textColor = textSecondaryColor
        detailsLabel.font = UIFont(name: "Roboto-Regular", size: 14)
        detailsLabel.lineBreakMode = .byWordWrapping
        detailsLabel.numberOfLines = 0
        detailsLabel.top(to: .bottom(16), of: separatorView).left(16).right(16).bottom(76)
    }

}
