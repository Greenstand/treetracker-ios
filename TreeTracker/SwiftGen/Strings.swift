// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {

  internal enum App {
    /// Greenstand Tree Tracker
    internal static let title = L10n.tr("Localizable", "App.Title")
  }

  internal enum TextInput {
    internal enum Email {
      /// Or Email Address
      internal static let placeholder = L10n.tr("Localizable", "TextInput.Email.Placeholder")
    }
    internal enum FirstName {
      /// First Name
      internal static let placeholder = L10n.tr("Localizable", "TextInput.FirstName.Placeholder")
    }
    internal enum LastName {
      /// Last Name
      internal static let placeholder = L10n.tr("Localizable", "TextInput.LastName.Placeholder")
    }
    internal enum Organization {
      /// Organization (optional)
      internal static let placeholder = L10n.tr("Localizable", "TextInput.Organization.Placeholder")
    }
    internal enum PhoneNumber {
      /// Phone Number
      internal static let placeholder = L10n.tr("Localizable", "TextInput.PhoneNumber.Placeholder")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    // swiftlint:disable:next nslocalizedstring_key
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
