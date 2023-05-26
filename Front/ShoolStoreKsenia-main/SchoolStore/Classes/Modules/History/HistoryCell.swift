
import Foundation
import UIKit
import Kingfisher
import AutoLayoutSugar

class HistoryCell: UITableViewCell {
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

    var buyHandler: ((Order) -> Void)?
    var historyVC = HistoryVC()
    
    var modelHistory: Order? {
        didSet {
            
            numberDateOrder.text = modelHistory?.createdAt
            
            guard let status = modelHistory?.status else { return }
            
            if status == "in_work" {
                statusLabel.text = L10n.History.inWork
                statusLabel.textColor = .green
            } else if status == "done" {
                return
            } else {
                statusLabel.text = L10n.History.canceled
                statusLabel.textColor = .red
            }

            sizeNameOrder.text = modelHistory?.productSize
            
            if let preview = modelHistory?.productPrevieew, let previewUrl = URL(string: preview) {
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
            
            dateAdressOrder.text = modelHistory?.deliveryAddress
        }
    }
    
    var stopHistory: Order? {
        didSet{
            guard let status = modelHistory?.status else { return }
            
            if status == "in_work" {
                statusLabel.text = "В работе"
                statusLabel.textColor = .green
            } else if status == "done" {
                return
            } else {
                statusLabel.text = "Отменен"
                statusLabel.textColor = .red
            }
        }
    }

    

    // MARK: Private

    private lazy var contentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = Asset.itemPlaceholder.image
        return imageView
    }()

        private lazy var numberDateOrder: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = .systemFont(ofSize: 12, weight: .medium)
            label.lineBreakMode = NSLineBreakMode.byWordWrapping
            label.numberOfLines = 3
            return label
        }()
        private lazy var statusLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = .systemFont(ofSize: 16, weight: .medium)
            label.lineBreakMode = NSLineBreakMode.byWordWrapping
            label.numberOfLines = 2
            return label
        }()
        private lazy var sizeNameOrder: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = .systemFont(ofSize: 14, weight: .medium)
            label.lineBreakMode = NSLineBreakMode.byWordWrapping
            label.numberOfLines = 3
            return label
        }()
        private lazy var dateAdressOrder: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.lineBreakMode = NSLineBreakMode.byWordWrapping
            label.numberOfLines = 3
            label.font = .systemFont(ofSize: 10, weight: .medium)
            label.textColor = .gray
            label.alpha = 0.8
            return label
        }()
        private lazy var separatorView: UIView = {
                let view = UIView()
                view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = .gray
                return view
            }()
        




    private func setup() {
        selectionStyle = .none
        contentView.addSubview(contentImageView)
        
        contentView.addSubview(numberDateOrder)
        contentView.addSubview(statusLabel)
        contentView.addSubview(sizeNameOrder)
        contentView.addSubview(dateAdressOrder)
        contentView.addSubview(separatorView)
        
        
        
        contentImageView
            .top(16).left(16).width(63.02).height(64).bottom(69)
        
        
        
        numberDateOrder
            .top(16).left(to: .right(8), of: contentImageView).height(12)
        
        statusLabel
            .top(to: .bottom(8), of: numberDateOrder).left(to: .right(8), of: contentImageView).width(203).height(17)
        
        
        sizeNameOrder.top(to: .bottom(8), of: statusLabel).left(to: . right(8), of: contentImageView).width(257).height(28)
        
        dateAdressOrder
            .top(to: .bottom(8), of: sizeNameOrder).left(to: .right(8), of: contentImageView).width(257).height(36)
        
        separatorView
            .bottom().left(16).right(16).height(1)
        
        separatorView.backgroundColor = Asset.fieldBacground.color
        separatorView.bottom().left(16).right(16).height(1)
    }
    
}


