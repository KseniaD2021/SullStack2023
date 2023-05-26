
import UIKit

public struct DefaultBottomSheetStyle: BottomSheetStyle {
    // MARK: Lifecycle

    public init(
        cornerRadius: CGFloat = 24,
        backgroundColor: UIColor = .white,
        arrowSize: CGSize = .init(width: 35, height: 5),
        arrowCornerRadius: CGFloat = 2.5,
        arrowColor: UIColor = .lightGray,
        arrowTopOffset: CGFloat = 10,
        arrowToContent: CGFloat = 10,
        contentMargin: UIEdgeInsets = .init(top: 32, left: 24, bottom: 0, right: 24),
        bottomSheetTopOffset: CGFloat = 0
    ) {
        self.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
        self.arrowColor = arrowColor
        self.arrowSize = arrowSize
        self.arrowCornerRadius = arrowCornerRadius
        self.arrowTopOffset = arrowTopOffset
        self.arrowToContent = arrowToContent
        self.contentMargin = contentMargin
        self.bottomSheetTopOffset = bottomSheetTopOffset
    }

    // MARK: Public

    public var cornerRadius: CGFloat
    public var backgroundColor: UIColor
    public var arrowSize: CGSize
    public var arrowCornerRadius: CGFloat
    public var arrowColor: UIColor
    public var arrowTopOffset: CGFloat
    public var arrowToContent: CGFloat
    public var contentMargin: UIEdgeInsets
    public var bottomSheetTopOffset: CGFloat
}

