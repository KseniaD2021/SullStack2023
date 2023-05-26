 
import Foundation

extension NumberFormatter {
    static let ruLocale = Locale(identifier: "ru_RU")

    private static let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = ruLocale
        formatter.groupingSeparator = " "
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        return formatter
    }()

    private static let rubFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = ruLocale
        formatter.currencyCode = "RUB"
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        return formatter
    }()

    static let decimalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .decimal
        return formatter
    }()

    static let decimalWithSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = " "
        formatter.numberStyle = .decimal
        return formatter
    }()

    static func rubString(from rubles: Int) -> String {
        Self.rubFormatter.string(from: rubles as NSNumber) ?? "\(rubles)"
    }

    static func rubString(from rubles: Double) -> String {
        Self.rubFormatter.string(from: rubles as NSNumber) ?? "\(rubles)"
    }

    static func currencyString(from: Double, code: String, for locale: Locale = NumberFormatter.ruLocale) -> String {
        currencyFormatter(with: code, for: locale).string(from: from as NSNumber) ?? "\(from)"
    }

    static func currencyString(from: Int, code: String, for locale: Locale = NumberFormatter.ruLocale) -> String {
        currencyFormatter(with: code, for: locale).string(from: from as NSNumber) ?? "\(from)"
    }

    static func doubleString(from double: Double, for _: Locale = NumberFormatter.ruLocale) -> String {
        let formatter = decimalFormatter
        formatter.groupingSeparator = ","
        formatter.maximumFractionDigits = 1
        return formatter.string(from: double as NSNumber) ?? "\(double)"
    }

    static func numberString(from number: Int) -> String {
        numberFormatter.string(from: number as NSNumber) ?? "\(number)"
    }

    static func numberString(from number: Double) -> String {
        numberFormatter.string(from: number as NSNumber) ?? "\(number)"
    }

    static func currencyFormatter(with code: String, for locale: Locale) -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = locale
        formatter.currencyCode = code
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        return formatter
    }

    static func doubleFormatter(maxFractionDigits: UInt = 1) -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = Int(maxFractionDigits)
        return formatter
    }
}
