//
//  Setting.swift
//  wallabag
//
//  Created by maxime marinel on 23/11/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import Foundation

class Setting {


    fileprivate enum const: String {
        case defaultMode
        case justifyArticle
        case articleTheme
    }

    static func getDefaultMode() -> RetrieveMode {
        guard let value = UserDefaults.standard.string(forKey: const.defaultMode.rawValue) else {
            return RetrieveMode.allArticles
        }
        return RetrieveMode(rawValue: value)!
    }

    static func setDefaultMode(mode: RetrieveMode) {
        UserDefaults.standard.set(mode.rawValue, forKey: const.defaultMode.rawValue)
    }

    static func isJustifyArticle() -> Bool {
        return UserDefaults.standard.bool(forKey: const.justifyArticle.rawValue)
    }

    static func setJustifyArticle(value: Bool) {
        UserDefaults.standard.set(value, forKey: const.justifyArticle.rawValue)
    }

    static func getTheme() -> ThemeManager.Theme {
        guard let value = UserDefaults.standard.string(forKey: const.articleTheme.rawValue) else {
            return ThemeManager.Theme.light
        }

        return ThemeManager.Theme(rawValue: value) ?? .light
    }

    static func setTheme(value: ThemeManager.Theme) {
        ThemeManager.apply(theme: value)
        UserDefaults.standard.set(value.rawValue, forKey: const.articleTheme.rawValue)
    }

    static func set(server: Server) {
        let shareDefaults = UserDefaults(suiteName: "group.wallabag.share_extension")
        shareDefaults?.set(server.host, forKey: "host")
        shareDefaults?.set(server.client_id, forKey: "clientId")
        shareDefaults?.set(server.client_secret, forKey: "clientSecret")
        shareDefaults?.set(server.username, forKey: "username")
        shareDefaults?.set(server.password, forKey: "password")
        shareDefaults?.set(true, forKey: "serverConfigured")
        shareDefaults?.synchronize()
    }
}