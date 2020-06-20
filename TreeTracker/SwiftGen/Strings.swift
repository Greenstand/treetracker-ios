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

  internal enum Selfie {
    /// Take Selfie
    internal static let title = L10n.tr("Localizable", "Selfie.Title")
    internal enum DoneButton {
      /// Take Selfie
      internal static let title = L10n.tr("Localizable", "Selfie.DoneButton.Title")
    }
    internal enum PhotoButton {
      internal enum TItle {
        /// Retake
        internal static let retake = L10n.tr("Localizable", "Selfie.PhotoButton.TItle.Retake")
        /// Take Photo
        internal static let takePhoto = L10n.tr("Localizable", "Selfie.PhotoButton.TItle.TakePhoto")
      }
    }
  }

  internal enum SignIn {
    /// Greenstand Tree Tracker
    internal static let title = L10n.tr("Localizable", "SignIn.Title")
    internal enum LoginButton {
      /// Login
      internal static let title = L10n.tr("Localizable", "SignIn.LoginButton.Title")
    }
    internal enum TextInput {
      internal enum Email {
        /// Or Email Address
        internal static let placeholder = L10n.tr("Localizable", "SignIn.TextInput.Email.Placeholder")
      }
      internal enum PhoneNumber {
        /// Phone Number
        internal static let placeholder = L10n.tr("Localizable", "SignIn.TextInput.PhoneNumber.Placeholder")
      }
    }
  }

  internal enum SignUp {
    /// Sign Up
    internal static let title = L10n.tr("Localizable", "SignUp.Title")
    internal enum SignUpButton {
      /// Sign Up
      internal static let title = L10n.tr("Localizable", "SignUp.SignUpButton.Title")
    }
    internal enum TextInput {
      internal enum FirstName {
        /// First Name
        internal static let placeholder = L10n.tr("Localizable", "SignUp.TextInput.FirstName.Placeholder")
      }
      internal enum LastName {
        /// Last Name
        internal static let placeholder = L10n.tr("Localizable", "SignUp.TextInput.LastName.Placeholder")
      }
      internal enum Organization {
        /// Organization (optional)
        internal static let placeholder = L10n.tr("Localizable", "SignUp.TextInput.Organization.Placeholder")
      }
    }
  }

  internal enum Terms {
    /// Terms & Conditions
    internal static let title = L10n.tr("Localizable", "Terms.Title")
    internal enum AcceptTermsButton {
      /// Sign Up
      internal static let title = L10n.tr("Localizable", "Terms.AcceptTermsButton.Title")
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
