import UIKit

// MARK: - UIView + UILoadable

extension UIView: UILoadable {
    var existedLoaderView: LoaderView? {
        subviews.first(where: { type(of: $0) == LoaderView.self }) as? LoaderView
    }

    func startLoading(with parameters: LoaderParameters) {
        let loaderView = existedLoaderView ?? LoaderView()
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        guard !loaderView.isLoading else {
            return
        }

        addSubview(loaderView)
        if parameters.installConstraints {
            NSLayoutConstraint.activate([
                loaderView.centerXAnchor.constraint(equalTo: centerXAnchor),
                loaderView.centerYAnchor.constraint(equalTo: centerYAnchor),
                loaderView.widthAnchor.constraint(equalToConstant: parameters.diameter),
                loaderView.heightAnchor.constraint(equalToConstant: parameters.diameter),
            ])
        }
        loaderView.parameters = parameters
        loaderView.animateLoading()
        loaderView.layer.zPosition = 999

        if parameters.isBlocker {
            isUserInteractionEnabled = false
        }
    }

    func stopLoadingProgress() {
        guard let loader = subviews.first(where: { type(of: $0) == LoaderView.self }) as? LoaderView else {
            return
        }
        let animation = {
            loader.alpha = 0.0
            loader.removeFromSuperview()
        }
        UIView.animate(withDuration: 0.5, animations: animation, completion: nil)
        if loader.parameters.isBlocker {
            isUserInteractionEnabled = true
        }
    }

    func setLoader(with parameters: LoaderParameters, on angle: CGFloat) {
        let loaderView = existedLoaderView ?? LoaderView()
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        stopLoadingProgress()
        addSubview(loaderView)
        if parameters.installConstraints {
            NSLayoutConstraint.activate([
                loaderView.centerXAnchor.constraint(equalTo: centerXAnchor),
                loaderView.centerYAnchor.constraint(equalTo: centerYAnchor),
                loaderView.widthAnchor.constraint(equalToConstant: parameters.diameter),
                loaderView.heightAnchor.constraint(equalToConstant: parameters.diameter),
            ])
        }
        loaderView.parameters = parameters
        loaderView.layer.zPosition = 999
        if parameters.isBlocker {
            isUserInteractionEnabled = false
        }
        loaderView.setRotationState(with: angle)
    }
}
