
import AutoLayoutSugar
import Foundation
import TTGSnackbar
import UIKit

// MARK: - Snacker

protocol Snacker: AnyObject {
    func show(snack: String, with style: SnackStyle)
}

// MARK: - SnackerImpl

class SnackerImpl: Snacker {
    // MARK: Lifecycle

    init() {}

    // MARK: Internal

    func show(snack: String, with style: SnackStyle) {
        DispatchQueue.main.async {
            self._show(snack: snack, with: style)
        }
    }

    // MARK: Private

    private static var statusBarHeight: CGFloat {
        UIApplication.shared.windows.first { $0.isKeyWindow }?.windowScene?.statusBarManager?.statusBarFrame.size.height ?? 0
    }

    private var snacks: [TTGSnackbar] = []

    private func _show(snack text: String, with style: SnackStyle) {
        if snacks.last?.message != text {
            let newSnack = snack(text, with: style)
            snacks.append(newSnack)

            DispatchQueue.main.async { [weak newSnack] in
                newSnack?.show()
            }

            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) { [unowned self] in
                self.remove(snack: newSnack)
            }
        }
    }

    private func getCustomView(with snack: String, _ style: SnackStyle) -> UIView {
        let snackView = SnackCustomView(style: style)
        snackView.translatesAutoresizingMaskIntoConstraints = false
        snackView.text = snack
        return snackView
    }

    private func snack(_ snack: String, with style: SnackStyle) -> TTGSnackbar {
        let customView: UIView = getCustomView(with: snack, style)
        let snackBar = TTGSnackbar(customContentView: customView, duration: .forever)
        snackBar.animationType = .slideFromTopBackToTop
        snackBar.cornerRadius = 12
        snackBar.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        snackBar.topMargin = -Self.statusBarHeight
        snackBar.message = snack
        snackBar.onTapBlock = { [weak self] snack in
            self?.remove(snack: snack)
        }
        snackBar.onSwipeBlock = { snack, direction in

            if direction == .right {
                snack.animationType = .slideFromLeftToRight
            } else if direction == .left {
                snack.animationType = .slideFromRightToLeft
            } else if direction == .up {
                snack.animationType = .slideFromTopBackToTop
            } else if direction == .down {
                snack.animationType = .slideFromTopBackToTop
            }

            self.remove(snack: snack)
        }

        return snackBar
    }

    private func remove(snack: TTGSnackbar) {
        if let index = snacks.firstIndex(of: snack) {
            snack.dismiss()
            snacks.remove(at: index)
        }
    }
}
