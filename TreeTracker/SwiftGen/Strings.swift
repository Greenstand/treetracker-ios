// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  internal enum AddTree {
    /// Add Tree
    internal static let title = L10n.tr("Localizable", "AddTree.Title", fallback: "Add Tree")
    internal enum PhotoButton {
      internal enum Title {
        /// Retake
        internal static let retake = L10n.tr("Localizable", "AddTree.PhotoButton.Title.Retake", fallback: "Retake")
        /// Take Photo
        internal static let takePhoto = L10n.tr("Localizable", "AddTree.PhotoButton.Title.TakePhoto", fallback: "Take Photo")
      }
    }
    internal enum PhotoLibraryButton {
      /// Choose Photo
      internal static let title = L10n.tr("Localizable", "AddTree.PhotoLibraryButton.Title", fallback: "Choose Photo")
    }
    internal enum SaveButton {
      /// Save
      internal static let title = L10n.tr("Localizable", "AddTree.SaveButton.Title", fallback: "Save")
    }
  }
  internal enum Alert {
    internal enum Button {
      /// Ok
      internal static let ok = L10n.tr("Localizable", "Alert.Button.Ok", fallback: "Ok")
    }
    internal enum Title {
      /// Error
      internal static let error = L10n.tr("Localizable", "Alert.Title.Error", fallback: "Error")
    }
  }
  internal enum Announce {
    /// Announcement
    internal static let title = L10n.tr("Localizable", "Announce.Title", fallback: "Announcement")
  }
  internal enum App {
    /// Localizable.strings
    ///   TreeTracker
    /// 
    ///   Created by Alex Cornforth on 13/05/2020.
    ///   Copyright © 2020 Greenstand. All rights reserved.
    internal static let title = L10n.tr("Localizable", "App.Title", fallback: "Greenstand Treetracker")
  }
  internal enum ChatList {
    internal enum DefaultCell {
      /// 
      internal static let fallbackTitle = L10n.tr("Localizable", "ChatList.DefaultCell.FallbackTitle", fallback: "")
    }
    internal enum MessageChatCell {
      /// Admin
      internal static let fallbackTitle = L10n.tr("Localizable", "ChatList.MessageChatCell.FallbackTitle", fallback: "Admin")
    }
    internal enum NoMessagesLabel {
      /// No messages
      internal static let text = L10n.tr("Localizable", "ChatList.NoMessagesLabel.Text", fallback: "No messages")
    }
  }
  internal enum DeleteAccountConfirmation {
    /// Are you sure you want to delete tour account? All your trees on this device will be lost.
    internal static let message = L10n.tr("Localizable", "DeleteAccountConfirmation.Message", fallback: "Are you sure you want to delete tour account? All your trees on this device will be lost.")
    /// Delete Account User
    internal static let title = L10n.tr("Localizable", "DeleteAccountConfirmation.Title", fallback: "Delete Account User")
    internal enum CancelButton {
      /// No, keep my trees
      internal static let title = L10n.tr("Localizable", "DeleteAccountConfirmation.CancelButton.Title", fallback: "No, keep my trees")
    }
    internal enum DeleteAccount {
      /// Yes, delete my account
      internal static let title = L10n.tr("Localizable", "DeleteAccountConfirmation.DeleteAccount.Title", fallback: "Yes, delete my account")
    }
  }
  internal enum GPSAccuracyLabel {
    internal enum Text {
      /// Bad
      internal static let bad = L10n.tr("Localizable", "GPSAccuracyLabel.Text.Bad", fallback: "Bad")
      /// GPS Accuracy: 
      internal static let base = L10n.tr("Localizable", "GPSAccuracyLabel.Text.Base", fallback: "GPS Accuracy: ")
      /// Good
      internal static let good = L10n.tr("Localizable", "GPSAccuracyLabel.Text.Good", fallback: "Good")
      /// Unknown
      internal static let unknown = L10n.tr("Localizable", "GPSAccuracyLabel.Text.Unknown", fallback: "Unknown")
    }
  }
  internal enum Home {
    /// Treetracker
    internal static let title = L10n.tr("Localizable", "Home.Title", fallback: "Treetracker")
    internal enum AddTreeButton {
      /// ADD TREE
      internal static let title = L10n.tr("Localizable", "Home.AddTreeButton.Title", fallback: "ADD TREE")
    }
    internal enum InfoLabel {
      internal enum TreesPlantedLabel {
        /// Trees Planted
        internal static let text = L10n.tr("Localizable", "Home.InfoLabel.TreesPlantedLabel.Text", fallback: "Trees Planted")
      }
      internal enum TreesUploadedLabel {
        /// Trees Uploaded
        internal static let text = L10n.tr("Localizable", "Home.InfoLabel.TreesUploadedLabel.Text", fallback: "Trees Uploaded")
      }
    }
    internal enum LogoutButton {
      /// Change User
      internal static let title = L10n.tr("Localizable", "Home.LogoutButton.Title", fallback: "Change User")
    }
    internal enum MessagingButton {
      /// MESSAGES
      internal static let title = L10n.tr("Localizable", "Home.MessagingButton.Title", fallback: "MESSAGES")
    }
    internal enum MyTreesButton {
      /// MY TREES
      internal static let title = L10n.tr("Localizable", "Home.MyTreesButton.Title", fallback: "MY TREES")
    }
    internal enum UploadTreesButton {
      internal enum Title {
        /// START UPLOAD
        internal static let start = L10n.tr("Localizable", "Home.UploadTreesButton.Title.Start", fallback: "START UPLOAD")
        /// STOP UPLOAD
        internal static let stop = L10n.tr("Localizable", "Home.UploadTreesButton.Title.Stop", fallback: "STOP UPLOAD")
      }
    }
  }
  internal enum Keyboard {
    internal enum Toolbar {
      internal enum DoneButton {
        /// Done
        internal static let title = L10n.tr("Localizable", "Keyboard.Toolbar.DoneButton.Title", fallback: "Done")
      }
    }
  }
  internal enum LogOutConfirmation {
    /// Are you sure you want to log out and change user?
    internal static let message = L10n.tr("Localizable", "LogOutConfirmation.Message", fallback: "Are you sure you want to log out and change user?")
    /// Change User
    internal static let title = L10n.tr("Localizable", "LogOutConfirmation.Title", fallback: "Change User")
    internal enum CancelButton {
      /// Cancel
      internal static let title = L10n.tr("Localizable", "LogOutConfirmation.CancelButton.Title", fallback: "Cancel")
    }
    internal enum LogOutButton {
      /// Log Out
      internal static let title = L10n.tr("Localizable", "LogOutConfirmation.LogOutButton.Title", fallback: "Log Out")
    }
  }
  internal enum Messages {
    /// Admin
    internal static let title = L10n.tr("Localizable", "Messages.Title", fallback: "Admin")
    internal enum InputTextView {
      /// Click to write a message
      internal static let placeHolder = L10n.tr("Localizable", "Messages.InputTextView.PlaceHolder", fallback: "Click to write a message")
    }
  }
  internal enum Notes {
    /// Add tree notes here.
    internal static let placeholder = L10n.tr("Localizable", "Notes.Placeholder", fallback: "Add tree notes here.")
    /// Notes
    internal static let title = L10n.tr("Localizable", "Notes.Title", fallback: "Notes")
  }
  internal enum Profile {
    /// My Profile
    internal static let fallbackTitle = L10n.tr("Localizable", "Profile.FallbackTitle", fallback: "My Profile")
    internal enum ChangeUserButton {
      /// Change User
      internal static let title = L10n.tr("Localizable", "Profile.ChangeUserButton.Title", fallback: "Change User")
    }
    internal enum DeleteAccountButton {
      /// Delete Account
      internal static let title = L10n.tr("Localizable", "Profile.DeleteAccountButton.Title", fallback: "Delete Account")
    }
    internal enum HeaderLabel {
      /// Email Address
      internal static let email = L10n.tr("Localizable", "Profile.HeaderLabel.Email", fallback: "Email Address")
      /// Name
      internal static let name = L10n.tr("Localizable", "Profile.HeaderLabel.Name", fallback: "Name")
      /// Organization
      internal static let organization = L10n.tr("Localizable", "Profile.HeaderLabel.Organization", fallback: "Organization")
      /// Phone Number
      internal static let phone = L10n.tr("Localizable", "Profile.HeaderLabel.Phone", fallback: "Phone Number")
      /// Username
      internal static let username = L10n.tr("Localizable", "Profile.HeaderLabel.Username", fallback: "Username")
    }
  }
  internal enum Selfie {
    /// Take Selfie
    internal static let title = L10n.tr("Localizable", "Selfie.Title", fallback: "Take Selfie")
    internal enum LibraryButton {
      internal enum Title {
        /// From library
        internal static let libraryPhoto = L10n.tr("Localizable", "Selfie.LibraryButton.Title.LibraryPhoto", fallback: "From library")
      }
    }
    internal enum PhotoButton {
      internal enum Title {
        /// Retake
        internal static let retake = L10n.tr("Localizable", "Selfie.PhotoButton.Title.Retake", fallback: "Retake")
        /// Take Photo
        internal static let takePhoto = L10n.tr("Localizable", "Selfie.PhotoButton.Title.TakePhoto", fallback: "Take Photo")
      }
    }
    internal enum SaveButton {
      /// Save
      internal static let title = L10n.tr("Localizable", "Selfie.SaveButton.Title", fallback: "Save")
    }
  }
  internal enum Settings {
    /// Settings
    internal static let title = L10n.tr("Localizable", "Settings.Title", fallback: "Settings")
    internal enum PhotoQuality {
      /// Photo Quality
      internal static let title = L10n.tr("Localizable", "Settings.PhotoQuality.Title", fallback: "Photo Quality")
      internal enum Option {
        internal enum High {
          /// High resolution, high data usage.
          internal static let info = L10n.tr("Localizable", "Settings.PhotoQuality.Option.High.Info", fallback: "High resolution, high data usage.")
          /// High
          internal static let title = L10n.tr("Localizable", "Settings.PhotoQuality.Option.High.Title", fallback: "High")
        }
        internal enum Low {
          /// Low resolution, low data usage.
          internal static let info = L10n.tr("Localizable", "Settings.PhotoQuality.Option.Low.Info", fallback: "Low resolution, low data usage.")
          /// Low
          internal static let title = L10n.tr("Localizable", "Settings.PhotoQuality.Option.Low.Title", fallback: "Low")
        }
        internal enum Medium {
          /// Medium resolution, medium data usage.
          internal static let info = L10n.tr("Localizable", "Settings.PhotoQuality.Option.Medium.Info", fallback: "Medium resolution, medium data usage.")
          /// Medium
          internal static let title = L10n.tr("Localizable", "Settings.PhotoQuality.Option.Medium.Title", fallback: "Medium")
        }
      }
    }
  }
  internal enum SignIn {
    /// Sign In
    internal static let title = L10n.tr("Localizable", "SignIn.Title", fallback: "Sign In")
    internal enum LoginButton {
      /// Log In
      internal static let title = L10n.tr("Localizable", "SignIn.LoginButton.Title", fallback: "Log In")
    }
    internal enum OrLabel {
      /// or
      internal static let text = L10n.tr("Localizable", "SignIn.OrLabel.Text", fallback: "or")
    }
    internal enum TextInput {
      internal enum Email {
        /// Email Address
        internal static let placeholder = L10n.tr("Localizable", "SignIn.TextInput.Email.Placeholder", fallback: "Email Address")
      }
      internal enum PhoneNumber {
        /// Phone Number
        internal static let placeholder = L10n.tr("Localizable", "SignIn.TextInput.PhoneNumber.Placeholder", fallback: "Phone Number")
      }
    }
  }
  internal enum SignUp {
    /// Sign Up
    internal static let title = L10n.tr("Localizable", "SignUp.Title", fallback: "Sign Up")
    internal enum SignUpButton {
      /// Sign Up
      internal static let title = L10n.tr("Localizable", "SignUp.SignUpButton.Title", fallback: "Sign Up")
    }
    internal enum TextInput {
      internal enum FirstName {
        /// First Name
        internal static let placeholder = L10n.tr("Localizable", "SignUp.TextInput.FirstName.Placeholder", fallback: "First Name")
      }
      internal enum LastName {
        /// Last Name
        internal static let placeholder = L10n.tr("Localizable", "SignUp.TextInput.LastName.Placeholder", fallback: "Last Name")
      }
      internal enum Organization {
        /// Organization (optional)
        internal static let placeholder = L10n.tr("Localizable", "SignUp.TextInput.Organization.Placeholder", fallback: "Organization (optional)")
      }
    }
  }
  internal enum Survey {
    internal enum ActionButton {
      internal enum Title {
        /// Finish
        internal static let finish = L10n.tr("Localizable", "Survey.ActionButton.Title.Finish", fallback: "Finish")
        /// Next
        internal static let next = L10n.tr("Localizable", "Survey.ActionButton.Title.Next", fallback: "Next")
      }
    }
    internal enum Title {
      /// Question
      internal static let question = L10n.tr("Localizable", "Survey.Title.Question", fallback: "Question")
      /// Response
      internal static let response = L10n.tr("Localizable", "Survey.Title.Response", fallback: "Response")
    }
  }
  internal enum Terms {
    /// Terms & Conditions
    internal static let title = L10n.tr("Localizable", "Terms.Title", fallback: "Terms & Conditions")
    internal enum AcceptTermsButton {
      /// Accept Terms
      internal static let title = L10n.tr("Localizable", "Terms.AcceptTermsButton.Title", fallback: "Accept Terms")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
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
