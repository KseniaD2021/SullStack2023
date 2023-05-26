
import AutoLayoutSugar
import UIKit

final class SnackCustomView: UIView {
    // MARK: Lifecycle

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("NSCoder init is not supported")
    }

    init(style: SnackStyle) {
        super.init(frame: CGRect.zero)
        let contentStackView = UIStackView(arrangedSubviews: [label])
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.axis = .horizontal
        contentStackView.spacing = 10
        contentStackView.alignment = .center
        contentStackView.layoutMargins = UIEdgeInsets(
            top: 16,
            left: 16,
            bottom: 16,
            right: 16
        )
        contentStackView.isLayoutMarginsRelativeArrangement = true

        addSubview(contentStackView)
        contentStackView.pinToSuperview()

        widthAnchor ~ UIScreen.main.bounds.width

        label.font = style.font
        label.textColor = style.textColor
        backgroundColor = style.backgroundColor
    }

    // MARK: Internal

    var text: String = "" {
        didSet {
            label.text = text
        }
    }

    // MARK: Private

    // MARK: - Components

    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
}
