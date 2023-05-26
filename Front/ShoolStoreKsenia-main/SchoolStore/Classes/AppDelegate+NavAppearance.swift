 
import UIKit

extension AppDelegate {
    func configureNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = .clear
        appearance.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: Asset.white.color,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .medium),
        ]
        appearance.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: Asset.white.color,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .medium),
        ]

        let font = UIFont.systemFont(ofSize: 14, weight: .medium)
        let barButtonAppearance = UIBarButtonItemAppearance()
        barButtonAppearance.configureWithDefault(for: .plain)
        barButtonAppearance.normal.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: Asset.greenBack.color,
            NSAttributedString.Key.font: font,
        ]
        barButtonAppearance.highlighted.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: Asset.greenBack.color,
            NSAttributedString.Key.font: font,
        ]
        appearance.buttonAppearance = barButtonAppearance

        appearance.backgroundColor = Asset.greenBack.color
        appearance.setBackIndicatorImage(Asset.navBack.image, transitionMaskImage: Asset.navBack.image)
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }
}
