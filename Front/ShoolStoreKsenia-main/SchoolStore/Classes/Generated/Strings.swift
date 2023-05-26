// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// Plural format key: "%#@VARIABLE@"
  internal static func ageValue(_ p1: Int) -> String {
    return L10n.tr("Localizable", "age-value", p1)
  }

  internal enum Action {
    /// Назад
    internal static let back = L10n.tr("Localizable", "action.back")
    /// Отменить
    internal static let cancel = L10n.tr("Localizable", "action.cancel")
    /// Удаление
    internal static let delete = L10n.tr("Localizable", "action.delete")
    /// Удалить
    internal static let deleteAction = L10n.tr("Localizable", "action.deleteAction")
    /// Ошибка
    internal static let error = L10n.tr("Localizable", "action.error")
    /// Вы не можете удалить активный заказ
    internal static let errorMsg = L10n.tr("Localizable", "action.errorMsg")
    /// Выход
    internal static let exit = L10n.tr("Localizable", "action.exit")
    /// Выйти
    internal static let exitAction = L10n.tr("Localizable", "action.exitAction")
    /// Ок
    internal static let ok = L10n.tr("Localizable", "action.ok")
  }

  internal enum Auth {
    /// Войти
    internal static let action = L10n.tr("Localizable", "auth.action")
    /// Логин
    internal static let login = L10n.tr("Localizable", "auth.login")
    /// Пароль
    internal static let password = L10n.tr("Localizable", "auth.password")
  }

  internal enum Catalog {
    /// Купить
    internal static let buy = L10n.tr("Localizable", "catalog.buy")
    /// Каталог
    internal static let title = L10n.tr("Localizable", "catalog.title")
  }

  internal enum Common {
    /// Поле пустое
    internal static let emptyField = L10n.tr("Localizable", "common.emptyField")
    /// Что-то пошло не так \n Повторите попытку позже
    internal static let error = L10n.tr("Localizable", "common.error")
  }

  internal enum EditingTitle {
    /// ИЗМЕНИТЬ
    internal static let action = L10n.tr("Localizable", "editingTitle.action")
    /// Другой пол
    internal static let anotherOccupation = L10n.tr("Localizable", "editingTitle.anotherOccupation")
    /// Род деятельности не изменился
    internal static let double = L10n.tr("Localizable", "editingTitle.double")
    /// Имя
    internal static let name = L10n.tr("Localizable", "editingTitle.name")
    /// Пол
    internal static let occupation = L10n.tr("Localizable", "editingTitle.occupation")
    /// Настройки
    internal static let settings = L10n.tr("Localizable", "editingTitle.settings")
    /// Фамилия
    internal static let surname = L10n.tr("Localizable", "editingTitle.surname")
    /// Редактирование профиля
    internal static let title = L10n.tr("Localizable", "editingTitle.title")
  }

  internal enum History {
    /// Завершен
    internal static let canceled = L10n.tr("Localizable", "history.canceled")
    /// В работе
    internal static let inWork = L10n.tr("Localizable", "history.inWork")
    /// Мои заказы
    internal static let title = L10n.tr("Localizable", "history.title")
  }

  internal enum Occupation {
    /// Мужчина
    internal static let androidDeveloper = L10n.tr("Localizable", "occupation.androidDeveloper")
    /// Другое
    internal static let another = L10n.tr("Localizable", "occupation.another")
    /// Женщина
    internal static let iosDeveloper = L10n.tr("Localizable", "occupation.iosDeveloper")
    /// Ребенок
    internal static let tester = L10n.tr("Localizable", "occupation.tester")
  }

  internal enum Order {
    /// Квартира
    internal static let apartment = L10n.tr("Localizable", "order.apartment")
    /// Город, улица, дом
    internal static let house = L10n.tr("Localizable", "order.house")
    /// Дата доставки
    internal static let orderDate = L10n.tr("Localizable", "order.orderDate")
    /// Купить за 
    internal static let payTitle = L10n.tr("Localizable", "order.payTitle")
    /// Оформление заказа
    internal static let title = L10n.tr("Localizable", "order.title")
  }

  internal enum Product {
    /// LiteSummer
    internal static let badge = L10n.tr("Localizable", "product.badge")
    /// КУПИТЬ СЕЙЧАС
    internal static let payTitle = L10n.tr("Localizable", "product.payTitle")
    /// Размер
    internal static let size = L10n.tr("Localizable", "product.size")
    /// L
    internal static let sizeL = L10n.tr("Localizable", "product.sizeL")
    /// M
    internal static let sizeM = L10n.tr("Localizable", "product.sizeM")
    /// S
    internal static let sizeS = L10n.tr("Localizable", "product.sizeS")
    /// XL
    internal static let sizeXL = L10n.tr("Localizable", "product.sizeXL")
  }

  internal enum Profile {
    /// Профиль
    internal static let title = L10n.tr("Localizable", "profile.title")
  }

  internal enum Question {
    /// Хотите удалить заказ из истории?
    internal static let delete = L10n.tr("Localizable", "question.delete")
    /// Хотите выйти?
    internal static let exit = L10n.tr("Localizable", "question.exit")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
