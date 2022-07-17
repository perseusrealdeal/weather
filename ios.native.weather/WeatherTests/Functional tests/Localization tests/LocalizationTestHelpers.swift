//
//  LocalizationTestHelpers.swift
//  WeatherTests
//
//  Created by Mikhail Zhigulin on 10.12.2021.
//

import Foundation

extension String {
    var localizedFromSettings: String {
        guard let path = Bundle.main.path(forResource: "Settings", ofType: "bundle")
        else { print("Path to Settings.bundle hasn't been found."); return "?" }

        guard let settingBundle = Bundle.init(path: path)
        else { print("Something went wrong with Settings.bundle initialization."); return "?" }

        return NSLocalizedString(self, tableName: "Root", bundle: settingBundle, value: "Not found", comment: "")
    }

    var localizedFromInfoPlist: String {
        return NSLocalizedString(self, tableName: "InfoPlist", bundle: Bundle.main, value: "Not found", comment: "")
    }

    var localizedFromRequirements: String {
        guard let currentLang = LocalizationTestHelper.currentLanguage?.langCode
        else { print("Something wrong with getting current language."); return "?" }

        let lang = ["en", "ru"].contains(currentLang) ? currentLang : "en"

        guard let path = Bundle.main.url(forResource: "Localization_\(lang)", withExtension: "plist")
        else { print("Something wrong with getting current language."); return "?" }

        guard let data = try? Data(contentsOf: path)
        else { print("Not possible to exctract data from property list."); return "?" }

        guard let result = try? PropertyListSerialization.propertyList(from: data,
                                                                       options: [],
                                                                       format: nil)
                as? [String:String]
        else { print("Not possible to serialize the property list."); return "?" }

        guard let value = result[self]
        else { print("No such value according to the key: \(self)."); return "?" }

        return value
    }
}

fileprivate final class LocalizationTestHelper {
    static var currentLanguage: (langCode: String, localeCode: String)? {
        let currentLocale = Locale(identifier: Locale.preferredLanguages.first!)
        guard let langCode = currentLocale.languageCode else { return nil }

        var localeCode = langCode

        if let scriptCode = currentLocale.scriptCode { localeCode = "\(langCode)-\(scriptCode)" } else
        if let regionCode = currentLocale.regionCode { localeCode = "\(langCode)-\(regionCode)" }

        return (langCode, localeCode)
    }
}
