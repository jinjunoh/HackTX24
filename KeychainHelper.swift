//
//  KeychainHelper.swift
//  HackTX24
//
//  Created by Joseph on 11/3/24.
//


import Security
import Foundation

class KeychainHelper {
    static func save(key: String, data: Data) -> Bool {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: data
        ] as CFDictionary

        SecItemDelete(query) // Delete any existing item
        return SecItemAdd(query, nil) == errSecSuccess
    }

    static func load(key: String) -> Data? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ] as CFDictionary

        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query, &dataTypeRef)
        return (status == errSecSuccess) ? dataTypeRef as? Data : nil
    }

    static func delete(key: String) {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ] as CFDictionary

        SecItemDelete(query)
    }
}

extension KeychainHelper {
    static func savePassword(_ password: String, for username: String) -> Bool {
        guard let passwordData = password.data(using: .utf8) else { return false }
        return save(key: username, data: passwordData)
    }

    static func getPassword(for username: String) -> String? {
        guard let passwordData = load(key: username) else { return nil }
        return String(data: passwordData, encoding: .utf8)
    }
    
    static func removePassword(for username: String) -> Bool {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: username
        ] as [String: Any]
        
        return SecItemDelete(query as CFDictionary) == errSecSuccess
    }
}
