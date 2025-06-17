//
//  AuthManager.swift
//  SwiftUI_Laravel
//
//  Created by JoshipTy on 17/4/25.
//


import Foundation
import KeychainAccess

class AuthManager: ObservableObject {
    @Published var isAuthenticated = false
    private let keychain = Keychain(service: "com.yourapp")
    
    func checkTokenValidity() {
        guard let token = try? keychain.get("auth_token") else {
            self.isAuthenticated = false
            return
        }
        
        // Make a request to the backend to validate the token
        verifyToken(token: token) { success in
            if success {
                self.isAuthenticated = true
            } else {
                self.isAuthenticated = false
                self.removeToken()
            }
        }
    }
    
    private func verifyToken(token: String, completion: @escaping (Bool) -> Void) {
        // Make an API call to check if the token is valid
        let url = URL(string: "http://127.0.0.1:8000/api/profile")!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error verifying token: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(false)
                }
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                DispatchQueue.main.async {
                    completion(true)
                }
            } else {
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
        
        task.resume()
    }
    
    func removeToken() {
        do {
            try keychain.remove("auth_token")
        } catch let error {
            print("Error removing token: \(error)")
        }
    }
}
