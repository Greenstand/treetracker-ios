//
//  SettingsService.swift
//  Treetracker-Core
//
//  Created by Alex Cornforth on 03/04/2022.
//

import Foundation

public enum SettingKey: String {
    case treePhotoSize
    case treePhotoCompression

}

public protocol SettingsService {
    func value<T>(forSetting settingKey: SettingKey) -> T?
    func update(value: Any, forSetting settingKey: SettingKey)
}

public class UserDefaultsSettingsService: SettingsService {

    private let userDefaults: UserDefaults
    private let configuration: TreetrackerSDK.Configuration

    init(
        userDefaults: UserDefaults = .standard,
        configuration: TreetrackerSDK.Configuration
    ) {
        self.userDefaults = userDefaults
        self.configuration = configuration
    }

    public func value<T>(forSetting settingKey: SettingKey) -> T? {
        return (userDefaults.value(forKey: settingKey.rawValue) ?? settingKey.defaultValue) as? T
    }

    public func update(value: Any, forSetting settingKey: SettingKey) {
        self.userDefaults.setValue(value, forKey: settingKey.rawValue)
    }
}

fileprivate extension SettingKey {

    func defaultValue(configuration: TreetrackerSDK.Configuration) -> Any {
        switch self {
        case .treePhotoSize:
            return configuration.defaultTreeImageQuality.size
        case .treePhotoCompression:
            return configuration.defaultTreeImageQuality.compression
        }
    }
}
