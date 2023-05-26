
import AutoLayoutSugar
import Foundation
import Kingfisher
import UIKit

final class ProductCell: UITableViewCell {
    // MARK: Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    // MARK: Internal

    var buyHandler: ((Product) -> Void)?

    var model: Product? {
        didSet {
            titleLabel.text = model?.title
            descriptionLabel.text = model?.department
            if let preview = model?.preview, let previewUrl = URL(string: preview) {
                let contentImageResource = ImageResource(downloadURL: previewUrl, cacheKey: preview)
                contentImageView.kf.setImage(
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
                contentImageView.image = Asset.itemPlaceholder.image
            }

            priceLabel.text = NumberFormatter.rubString(from: model?.price ?? 0)
        }
    }

    // MARK: Private

    private lazy var contentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = Asset.itemPlaceholder.image
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = Asset.textSecondary.color
        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()

    private lazy var addToCartButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(Asset.itemAddToCart.image, for: .normal)
        button.setTitle(L10n.Catalog.buy.uppercased(), for: .normal)
        button.addTarget(self, action: #selector(buyPressed), for: .touchUpInside)
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.setTitleColor(Asset.buyTint.color, for: .normal)
        button.tintColor = Asset.buyTint.color
        button.imageEdgeInsets.left = -5
        button.imageEdgeInsets.right = 5
        return button
    }()

    private lazy var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    @objc
    private func buyPressed() {
        guard let product = model else {
            return
        }
        buyHandler?(product)
    }

    private func setup() {
        selectionStyle = .none
        contentView.addSubview(contentImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(addToCartButton)
        contentView.addSubview(separatorView)

        contentImageView
            .top(16).left(16).bottom(16).width(112).height(112)

        titleLabel
            .top(16).left(to: .right(16), of: contentImageView)
            .right(16)

        descriptionLabel
            .top(to: .bottom, of: titleLabel)
            .left(to: .right(16), of: contentImageView).right(16)

        priceLabel
            .left(to: .right(16), of: contentImageView)
            .bottom(31)

        priceLabel.trailingAnchor.constraint(lessThanOrEqualTo: addToCartButton.leadingAnchor).priority(999).activate()
        addToCartButton
            .width(90).height(28)
            .top(to: .top, of: priceLabel)
            .bottom(31)
            .right(16)

        separatorView.backgroundColor = Asset.fieldBacground.color
        separatorView.bottom().left(16).right(16).height(1)
    }
    
}
