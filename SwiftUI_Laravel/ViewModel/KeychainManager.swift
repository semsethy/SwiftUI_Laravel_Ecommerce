//
//  KeychainManager.swift
//  SwiftUI_Laravel
//
//  Created by JoshipTy on 17/4/25.
//


import KeychainAccess

class KeychainManager {
    private let keychain = Keychain(service: "com.yourapp")
    
    // Save Token
    func saveToken(token: String) {
        do {
            try keychain.set(token, key: "auth_token")
        } catch let error {
            print("Error saving token: \(error)")
        }
    }
    
    // Retrieve Token
    func getToken() -> String? {
        do {
            return try keychain.get("auth_token")
        } catch let error {
            print("Error retrieving token: \(error)")
            return nil
        }
    }
    
    // Remove Token
    func removeToken() {
        do {
            try keychain.remove("auth_token")
        } catch let error {
            print("Error removing token: \(error)")
        }
    }
}
