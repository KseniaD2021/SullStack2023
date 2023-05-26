

import AutoLayoutSugar
import UIKit

// MARK: - BottomSheetController

public final class BottomSheetController: UIViewController, UIGestureRecognizerDelegate, UIScrollViewDelegate,
    UIViewControllerTransitioningDelegate
{
    // MARK: Lifecycle

    public init(arguments: BottomSheetParametersProtocol, style: BottomSheetStyle = DefaultBottomSheetStyle()) {
        self.arguments = arguments
        self.style = style
        super.init(nibName: nil, bundle: nil)
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureHandler(recognizer:)))
        modalPresentationStyle = .custom

        panGesture.delegate = self
        bottomSheetView.addGestureRecognizer(panGesture)

        addContentView()
        fillContent(with: arguments.contentView)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        arguments.customOnLoadSideEffect?()
    }

    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addDismissingGesture()
    }

    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presentationController?.containerView?.removeGestureRecognizer(dismissingTapGesture)
        bottomSheetView.removeGestureRecognizer(panGesture)
        view.removeGestureRecognizer(endEditingTG)
    }

    // MARK: Public

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            return panRecognizer.direction == .up || panRecognizer.direction == .down
        }
        return true
    }

    public func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith _: UIGestureRecognizer
    ) -> Bool {
        if gestureRecognizer == dismissingTapGesture {
            return true
        } else {
            return gestureRecognizer == endEditingTG
        }
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if gestureRecognizer == dismissingTapGesture {
            return !bottomSheetView.frame.contains(touch.location(in: view))
        }
        return true
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // draggingScrollBegan нужен чтобы проверить программный ли это скролл или от пользователя
        if (scrollView.contentOffset.y < 0 && draggingScrollBegan) || dismissScrollBegan {
            dismissScrollBegan = true
            if bottomConstraint.constant + -scrollView.contentOffset.y > Constants.bottomSafeInset {
                bottomConstraint.constant += -scrollView.contentOffset.y
            }
            let alpha = (initialBottomSheetHeight - bottomConstraint.constant) / 1000
            cPresentationController?.updateDimmingView(alpha: alpha)
            if scrollView.contentOffset.y < 0 || (bottomConstraint.constant - Constants.bottomSafeInset) > 5 {
                scrollView.contentOffset.y = 0
            }
        }
    }

    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        draggingScrollBegan = true
        initialBottomSheetCenter = scrollView.frame.height * 0.5
        initialBottomSheetHeight = scrollView.frame.height
    }

    public func scrollViewWillEndDragging(_: UIScrollView, withVelocity _: CGPoint, targetContentOffset _: UnsafeMutablePointer<CGPoint>) {
        draggingScrollBegan = false
        dismissScrollBegan = false
        if bottomConstraint.constant > initialBottomSheetCenter {
            dismissCurrentController()
        } else {
            resetTopConstraintConstant()
        }
    }

    public func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source _: UIViewController
    ) -> UIPresentationController? {
        if presented == self {
            let presentationVC = PresentationController(presentedViewController: presented, presenting: presenting)
            cPresentationController = presentationVC
            return presentationVC
        }
        return nil
    }

    // MARK: Internal

    enum Constants {
        static let bottomPadViewHeight: CGFloat = 50
        static let bottomSafeInset: CGFloat = UIApplication.shared.windows.first { $0.isKeyWindow }?.safeAreaInsets.bottom ?? 0

        static var statusBarHeight: CGFloat {
            UIApplication.shared.windows.first { $0.isKeyWindow }?.windowScene?.statusBarManager?.statusBarFrame.size.height ?? 0
        }
    }

    let arguments: BottomSheetParametersProtocol

    private(set) var endEditingTG: UITapGestureRecognizer!

    private(set) var dismissingTapGesture: UITapGestureRecognizer!

    private(set) lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.layoutMargins = style.contentMargin
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()

    // MARK: Private

    private let style: BottomSheetStyle

    // MARK: - Components

    private lazy var bottomSheetView: UIView = {
        let bottomSheetView = UIView()
        bottomSheetView.translatesAutoresizingMaskIntoConstraints = false
        bottomSheetView.backgroundColor = style.backgroundColor
        bottomSheetView.layer.cornerRadius = style.cornerRadius
        bottomSheetView.layer.masksToBounds = true
        bottomSheetView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return bottomSheetView
    }()

    private var panGesture: UIPanGestureRecognizer!

    private var initialBottomSheetCenter: CGFloat = 0

    private var initialBottomSheetHeight: CGFloat = 0

    private var draggingScrollBegan: Bool = false

    private var dismissScrollBegan = false

    private var cPresentationController: PresentationController?

    private var topConstraint: NSLayoutConstraint!

    private var bottomConstraint: NSLayoutConstraint!

    private lazy var arrowView: UIView = {
        let arrowView = UIView()
        arrowView.translatesAutoresizingMaskIntoConstraints = false
        let arrow = UIView()
        arrow.translatesAutoresizingMaskIntoConstraints = false
        arrow.backgroundColor = style.arrowColor
        arrow.layer.cornerRadius = style.arrowCornerRadius
        arrow.layer.masksToBounds = true
        arrow.width(style.arrowSize.width).height(style.arrowSize.height)
        arrowView.addSubview(arrow)
        arrow.centerX().top(style.arrowTopOffset)
        return arrowView
    }()

    private var maximumBottomSheetHeight: CGFloat {
        UIScreen.main.bounds.height - sheetTopEdgeDistance - arrowViewHeight
    }

    private var sheetTopEdgeDistance: CGFloat {
        Constants.statusBarHeight + style.bottomSheetTopOffset
    }

    private var arrowViewHeight: CGFloat {
        style.arrowSize.height + style.arrowTopOffset + style.arrowToContent
    }

    // MARK: - Public actions

    private func fillContent(with contentView: ScrollableView) {
        contentStackView.subviews.forEach { $0.removeFromSuperview() }
        contentStackView.addArrangedSubview(contentView)
        contentStackView.width(UIScreen.main.bounds.width)
        contentView.heightAnchor.constraint(
            equalToConstant: maximumBottomSheetHeight
        ).priority(.defaultLow).activate()

        contentView.heightAnchor.constraint(
            lessThanOrEqualToConstant: maximumBottomSheetHeight
        ).priority(.required).activate()

        if let contentViewAsScroll = contentView.innerScrollView, contentViewAsScroll.isScrollEnabled {
            contentViewAsScroll.delegate = self
        }

        contentView.setContentHuggingPriority(UILayoutPriority(249), for: .vertical)
        contentStackView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        bottomSheetView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        arrowView.isHidden = !arguments.hasArrow
    }

    // MARK: - Helpers

    private func addDismissingGesture() {
        dismissingTapGesture = UITapGestureRecognizer(target: self, action: #selector(viewDidTap))
        dismissingTapGesture.delegate = self
        dismissingTapGesture.cancelsTouchesInView = false
        presentationController?.containerView?.addGestureRecognizer(dismissingTapGesture)
    }

    @objc
    private func viewDidTap() {
        arguments.onEveryTapOut?()
        if arguments.shouldDismissOnTapOut {
            dismissCurrentController()
        } else if let action = arguments.customTapOutAction {
            action()
        }
    }

    private func dismissCurrentController() {
        dismiss(animated: true)
    }

    private func addContentView() {
        let bottomPadView = UIView()
        bottomPadView.translatesAutoresizingMaskIntoConstraints = false
        bottomPadView.backgroundColor = style.backgroundColor

        view.addSubview(bottomPadView)
        view.addSubview(bottomSheetView)

        bottomPadView.pin(excluding: .top).height(Constants.bottomPadViewHeight)
        bottomSheetView.left().right()
        topConstraint = bottomSheetView.topAnchor >~ view.topAnchor + sheetTopEdgeDistance
        bottomConstraint = bottomSheetView.bottomAnchor ~ view.bottomAnchor + Constants.bottomSafeInset
        [arrowView, contentStackView].forEach { bottomSheetView.addSubview($0) }

        arrowView.pin(excluding: .bottom).height(arrowViewHeight)
        contentStackView.left().right().top(to: .bottom(0), of: arrowView).safeArea { $0.bottom(Constants.bottomSafeInset + 24) }
        contentStackView.heightAnchor.constraint(lessThanOrEqualTo: bottomSheetView.heightAnchor, constant: -20).priority(999).activate()

        endEditingTG = UITapGestureRecognizer(target: self, action: #selector(viewShouldEndEditing))
        view.addGestureRecognizer(endEditingTG)
    }

    @objc
    private func viewShouldEndEditing() {
        view.endEditing(true)
    }

    @objc
    private func panGestureHandler(recognizer: UIPanGestureRecognizer) {
        viewShouldEndEditing()
        switch recognizer.state {
        case .began:
            initialBottomSheetCenter = (recognizer.view?.frame.height ?? 0) * 0.5
            initialBottomSheetHeight = recognizer.view?.frame.height ?? 0
        case .changed:
            if recognizer.translation(in: recognizer.view).y >= 0 {
                bottomConstraint.constant = recognizer.translation(in: recognizer.view).y + Constants.bottomSafeInset
            }
        case .ended, .cancelled, .failed:
            if recognizer.translation(in: recognizer.view).y > initialBottomSheetCenter {
                let alpha = (initialBottomSheetHeight - bottomConstraint.constant) / 1000
                cPresentationController?.updateDimmingView(alpha: alpha)
                dismissCurrentController()
            } else {
                resetTopConstraintConstant()
            }
        default:
            break
        }
    }

    private func resetTopConstraintConstant() {
        bottomConstraint.constant = Constants.bottomSafeInset
        layoutAnimated()
    }

    private func layoutAnimated() {
        UIView.animate(
            withDuration: 0.6,
            delay: 0.0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.1,
            animations: {
                self.view.layoutIfNeeded()
            }
        )
    }
}
