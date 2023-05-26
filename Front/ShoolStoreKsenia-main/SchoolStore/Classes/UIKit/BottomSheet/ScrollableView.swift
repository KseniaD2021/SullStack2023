
import Foundation
import UIKit

// MARK: - ScrollableView

public protocol ScrollableView: UIView {
    var innerScrollView: UIScrollView? { get }
}

// MARK: - UIView + ScrollableView

extension UIView: ScrollableView {}

public extension ScrollableView where Self: UIView {
    var innerScrollView: UIScrollView? { subviews.first as? UIScrollView }
}
