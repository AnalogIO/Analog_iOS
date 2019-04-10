//
//  Localizable.swift
//  Analog
//
//  Created by Frederik Christensen on 16/09/2018.
//  Copyright © 2018 analogio. All rights reserved.
//

import Foundation

@objc public final class Localizable: NSObject {
    fileprivate let contents: String
    
    public init(_ contents: String) {
        self.contents = contents
        super.init()
    }
}

public extension String {
    private static var vaListHandler: (_ key: String, _ arguments: CVaListPointer, _ locale: Locale?) -> String {
        return { return NSString(format: $0, locale: $2, arguments: $1) as String }
    }
    
    static func localized(_ key: Localizable) -> String {
        return key.contents
    }
    
    static func localizedFormat(_ key: Localizable, _ arguments: CVarArg...) -> String {
        return withVaList(arguments) { vaListHandler(key.contents, $0, nil) } as String
    }
}

public extension NSString {
    private static var vaListHandler: (_ key: String, _ arguments: CVaListPointer, _ locale: Locale?) -> NSString {
        return { return NSString(format: $0, locale: $2, arguments: $1) }
    }
    
    @objc static func localized(_ key: Localizable) -> NSString {
        return NSString(string: key.contents)
    }
    
    static func localizedFormat(_ key: Localizable, _ arguments: CVarArg...) -> NSString {
        return withVaList(arguments) { vaListHandler(key.contents, $0, nil) }
    }
}
