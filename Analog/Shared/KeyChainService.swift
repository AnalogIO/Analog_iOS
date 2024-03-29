//
//  KeyChainService.swift
//  Analog
//
//  Created by Frederik Christensen on 16/09/2018.
//  Copyright © 2018 analogio. All rights reserved.
//

import Foundation

public class KeyChainService {

    public enum Key: String {
        case token = "token"
        case email = "email"
        case pin = "pin"
    }

    private static var _shared: KeyChainService?
    public static var shared: KeyChainService {
        get {
            guard let shared = _shared else {
                let service = KeyChainService()
                self._shared = service
                return service
            }
            return shared
        }
    }

    public func store(key: Key, value: String) {
        DispatchQueue.global().sync(flags: .barrier) {
            self.save(value, forKey: key.rawValue)
        }
    }

    public func get(key: Key) -> String? {
        return load(withKey: key.rawValue)
    }

    private func save(_ string: String?, forKey key: String) {
        let query = keychainQuery(withKey: key)
        let objectData: Data? = string?.data(using: .utf8, allowLossyConversion: false)

        if SecItemCopyMatching(query, nil) == noErr {
            if let dictData = objectData {
                let status = SecItemUpdate(query, NSDictionary(dictionary: [kSecValueData: dictData]))
                print("Update status: ", status)
            } else {
                let status = SecItemDelete(query)
                print("Delete status: ", status)
            }
        } else {
            if let dictData = objectData {
                query.setValue(dictData, forKey: kSecValueData as String)
                let status = SecItemAdd(query, nil)
                print("Update status: ", status)
            }
        }
    }

    private func load(withKey key: String) -> String? {
        let query = keychainQuery(withKey: key)
        query.setValue(kCFBooleanTrue, forKey: kSecReturnData as String)
        query.setValue(kCFBooleanTrue, forKey: kSecReturnAttributes as String)

        var result: CFTypeRef?
        let status = SecItemCopyMatching(query, &result)

        guard
            let resultsDict = result as? NSDictionary,
            let resultsData = resultsDict.value(forKey: kSecValueData as String) as? Data,
            status == noErr
            else {
                print("Load status: ", status)
                return nil
        }
        return String(data: resultsData, encoding: .utf8)
    }

    private func keychainQuery(withKey key: String) -> NSMutableDictionary {
        let result = NSMutableDictionary()
        result.setValue(kSecClassGenericPassword, forKey: kSecClass as String)
        result.setValue(key, forKey: kSecAttrService as String)
        result.setValue(kSecAttrAccessibleAlwaysThisDeviceOnly, forKey: kSecAttrAccessible as String)
        return result
    }
}
