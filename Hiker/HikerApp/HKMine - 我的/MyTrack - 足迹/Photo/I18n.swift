//
//  I18nswift.swift
//  Show
//
//  Created by nine on 2018/9/10.
//

import Foundation

class I18n {
    class func localizedString(_ key: String?) -> String {
        guard let key = key else { return "" }
        return NSLocalizedString(key, tableName: nil, bundle: Bundle(for: I18n.self), value: "", comment: "")
    }
}
