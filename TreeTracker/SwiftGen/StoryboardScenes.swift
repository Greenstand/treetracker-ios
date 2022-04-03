// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

// swiftlint:disable sorted_imports
import Foundation
import UIKit

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Storyboard Scenes

// swiftlint:disable explicit_type_interface identifier_name line_length type_body_length type_name
internal enum StoryboardScene {
  internal enum AddTree: StoryboardType {
    internal static let storyboardName = "AddTree"

    internal static let initialScene = InitialSceneType<TreeTracker.AddTreeViewController>(storyboard: AddTree.self)
  }
  internal enum Home: StoryboardType {
    internal static let storyboardName = "Home"

    internal static let initialScene = InitialSceneType<TreeTracker.HomeViewController>(storyboard: Home.self)
  }
  internal enum LaunchScreen: StoryboardType {
    internal static let storyboardName = "LaunchScreen"

    internal static let initialScene = InitialSceneType<UIKit.UIViewController>(storyboard: LaunchScreen.self)
  }
  internal enum Loading: StoryboardType {
    internal static let storyboardName = "Loading"

    internal static let initialScene = InitialSceneType<TreeTracker.LoadingViewController>(storyboard: Loading.self)
  }
  internal enum Profile: StoryboardType {
    internal static let storyboardName = "Profile"

    internal static let initialScene = InitialSceneType<TreeTracker.ProfileViewController>(storyboard: Profile.self)
  }
  internal enum Selfie: StoryboardType {
    internal static let storyboardName = "Selfie"

    internal static let initialScene = InitialSceneType<TreeTracker.SelfieViewController>(storyboard: Selfie.self)
  }
  internal enum Settings: StoryboardType {
    internal static let storyboardName = "Settings"

    internal static let initialScene = InitialSceneType<TreeTracker.SettingsViewController>(storyboard: Settings.self)
  }
  internal enum SignIn: StoryboardType {
    internal static let storyboardName = "SignIn"

    internal static let initialScene = InitialSceneType<TreeTracker.SignInViewController>(storyboard: SignIn.self)
  }
  internal enum SignUp: StoryboardType {
    internal static let storyboardName = "SignUp"

    internal static let initialScene = InitialSceneType<TreeTracker.SignUpViewController>(storyboard: SignUp.self)
  }
  internal enum Terms: StoryboardType {
    internal static let storyboardName = "Terms"

    internal static let initialScene = InitialSceneType<TreeTracker.TermsViewController>(storyboard: Terms.self)
  }
}
// swiftlint:enable explicit_type_interface identifier_name line_length type_body_length type_name

// MARK: - Implementation Details

internal protocol StoryboardType {
  static var storyboardName: String { get }
}

internal extension StoryboardType {
  static var storyboard: UIStoryboard {
    let name = self.storyboardName
    return UIStoryboard(name: name, bundle: Bundle(for: BundleToken.self))
  }
}

internal struct SceneType<T: UIViewController> {
  internal let storyboard: StoryboardType.Type
  internal let identifier: String

  internal func instantiate() -> T {
    let identifier = self.identifier
    guard let controller = storyboard.storyboard.instantiateViewController(withIdentifier: identifier) as? T else {
      fatalError("ViewController '\(identifier)' is not of the expected class \(T.self).")
    }
    return controller
  }
}

internal struct InitialSceneType<T: UIViewController> {
  internal let storyboard: StoryboardType.Type

  internal func instantiate() -> T {
    guard let controller = storyboard.storyboard.instantiateInitialViewController() as? T else {
      fatalError("ViewController is not of the expected class \(T.self).")
    }
    return controller
  }
}

private final class BundleToken {}
