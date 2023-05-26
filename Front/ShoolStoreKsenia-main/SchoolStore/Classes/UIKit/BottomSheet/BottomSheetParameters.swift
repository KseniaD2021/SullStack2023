
import UIKit

public struct BottomSheetParameters: BottomSheetParametersProtocol {
    // MARK: Lifecycle

    public init(
        hasArrow: Bool = true,
        shouldDismissOnTapOut: Bool = true,
        contentView: ScrollableView,
        customOnLoadSideEffect: (() -> Void)? = nil,
        customTapOutAction: (() -> Void)? = nil,
        onEveryTapOut: (() -> Void)? = nil
    ) {
        self.hasArrow = hasArrow
        self.shouldDismissOnTapOut = shouldDismissOnTapOut
        self.contentView = contentView
        self.customOnLoadSideEffect = customOnLoadSideEffect
        self.customTapOutAction = customTapOutAction
        self.onEveryTapOut = onEveryTapOut
    }

    // MARK: Public

    public var hasArrow: Bool = true
    public var shouldDismissOnTapOut: Bool = true
    public var contentView: ScrollableView
    public var customOnLoadSideEffect: (() -> Void)?
    public var customTapOutAction: (() -> Void)?
    public var onEveryTapOut: (() -> Void)?
}
