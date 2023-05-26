
import Foundation

public protocol BottomSheetParametersProtocol {
    var hasArrow: Bool {
        get
    }
    var shouldDismissOnTapOut: Bool {
        get
    }
    var contentView: ScrollableView {
        get
    }
    var customOnLoadSideEffect: (() -> Void)? {
        get
    }
    var customTapOutAction: (() -> Void)? {
        get
    }

    var onEveryTapOut: (() -> Void)? {
        get
    }
}
