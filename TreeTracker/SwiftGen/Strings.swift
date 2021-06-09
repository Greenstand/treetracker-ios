// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {

  internal enum AddTree {
    /// Add Tree
    internal static let title = L10n.tr("Localizable", "AddTree.Title")
    internal enum PhotoButton {
      internal enum Title {
        /// Retake
        internal static let retake = L10n.tr("Localizable", "AddTree.PhotoButton.Title.Retake")
        /// Take Photo
        internal static let takePhoto = L10n.tr("Localizable", "AddTree.PhotoButton.Title.TakePhoto")
      }
    }
    internal enum PhotoLibraryButton {
      /// Choose Photo
      internal static let title = L10n.tr("Localizable", "AddTree.PhotoLibraryButton.Title")
    }
    internal enum SaveButton {
      /// Save
      internal static let title = L10n.tr("Localizable", "AddTree.SaveButton.Title")
    }
  }

  internal enum Alert {
    internal enum Button {
      /// Ok
      internal static let ok = L10n.tr("Localizable", "Alert.Button.Ok")
    }
    internal enum Title {
      /// Error
      internal static let error = L10n.tr("Localizable", "Alert.Title.Error")
    }
  }

  internal enum App {
    /// Greenstand Tree Tracker
    internal static let title = L10n.tr("Localizable", "App.Title")
  }

  internal enum GPSAccuracyLabel {
    internal enum Text {
      /// Bad
      internal static let bad = L10n.tr("Localizable", "GPSAccuracyLabel.Text.Bad")
      /// GPS Accuracy: 
      internal static let base = L10n.tr("Localizable", "GPSAccuracyLabel.Text.Base")
      /// Good
      internal static let good = L10n.tr("Localizable", "GPSAccuracyLabel.Text.Good")
      /// Unknown
      internal static let unknown = L10n.tr("Localizable", "GPSAccuracyLabel.Text.Unknown")
    }
  }

  internal enum Home {
    /// Welcome %@
    internal static func title(_ p1: String) -> String {
      return L10n.tr("Localizable", "Home.Title", p1)
    }
    internal enum AddTreeButton {
      /// ADD TREE
      internal static let title = L10n.tr("Localizable", "Home.AddTreeButton.Title")
    }
    internal enum InfoLabel {
      internal enum TreesPlantedLabel {
        /// Trees Planted
        internal static let text = L10n.tr("Localizable", "Home.InfoLabel.TreesPlantedLabel.Text")
      }
      internal enum TreesUploadedLabel {
        /// Trees Uploaded
        internal static let text = L10n.tr("Localizable", "Home.InfoLabel.TreesUploadedLabel.Text")
      }
    }
    internal enum LogoutButton {
      /// Change User
      internal static let title = L10n.tr("Localizable", "Home.LogoutButton.Title")
    }
    internal enum MyTreesButton {
      /// MY TREES
      internal static let title = L10n.tr("Localizable", "Home.MyTreesButton.Title")
    }
    internal enum UploadTreesButton {
      internal enum Title {
        /// START UPLOAD
        internal static let start = L10n.tr("Localizable", "Home.UploadTreesButton.Title.Start")
        /// STOP UPLOAD
        internal static let stop = L10n.tr("Localizable", "Home.UploadTreesButton.Title.Stop")
      }
    }
  }

  internal enum Selfie {
    /// Take Selfie
    internal static let title = L10n.tr("Localizable", "Selfie.Title")
    internal enum LibraryButton {
      internal enum Title {
        /// From library
        internal static let libraryPhoto = L10n.tr("Localizable", "Selfie.LibraryButton.Title.LibraryPhoto")
      }
    }
    internal enum PhotoButton {
      internal enum Title {
        /// Retake
        internal static let retake = L10n.tr("Localizable", "Selfie.PhotoButton.Title.Retake")
        /// Take Photo
        internal static let takePhoto = L10n.tr("Localizable", "Selfie.PhotoButton.Title.TakePhoto")
      }
    }
    internal enum SaveButton {
      /// Save
      internal static let title = L10n.tr("Localizable", "Selfie.SaveButton.Title")
    }
  }

  internal enum SignIn {
    /// Sign In
    internal static let title = L10n.tr("Localizable", "SignIn.Title")
    internal enum LoginButton {
      /// Log In
      internal static let title = L10n.tr("Localizable", "SignIn.LoginButton.Title")
    }
    internal enum OrLabel {
      /// or
      internal static let text = L10n.tr("Localizable", "SignIn.OrLabel.Text")
    }
    internal enum TextInput {
      internal enum Email {
        /// Email Address
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
      /// Accept Terms
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
