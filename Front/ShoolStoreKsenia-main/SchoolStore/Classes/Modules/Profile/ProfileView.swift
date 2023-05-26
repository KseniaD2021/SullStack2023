
import UIKit
import AutoLayoutSugar

class ProfileView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    var contentView: UIView?
    
    func setup() {
        guard let view = loadFromNib() else {
            return
        }
        
        addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor),
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        contentView = view
    }
    
    func loadFromNib() -> UIView? {
        let view = Bundle.main.loadNibNamed("ProfileView", owner: self, options: nil)?.first as? UIView
        
        return view
    }

}


