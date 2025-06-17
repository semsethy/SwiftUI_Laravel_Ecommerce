//
//  SlideshowListView.swift
//  SwiftUI_Laravel
//
//  Created by JoshipTy on 10/4/25.
//


import SwiftUI
import Foundation
import Combine
import KeychainAccess
 
class SlideshowViewModel: ObservableObject {
    @Published var slideshows: [Slideshows] = []
    @Published var isLoaded = false
    @Published var errorMessage: String? = nil
    private let keychain = Keychain(service: "com.yourapp")
    private let imageCache = ImageCache()
    private let url = "http://127.0.0.1:8000/api/slideshows"

    func fetchSlideshows() {
        guard let url = URL(string: self.url) else { return }
        guard let token = try? keychain.get("auth_token") else {
            self.errorMessage = "Authentication token not found"
            return
        }
//        isLoaded = true
        errorMessage = nil
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            
            if let error = error {
                DispatchQueue.main.async {
                    self?.errorMessage = "Error: \(error.localizedDescription)"
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self?.errorMessage = "No data received."
                }
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(SlideshowResponse.self, from: data)
                DispatchQueue.main.async {
                    self?.slideshows = decodedResponse.slideshows
                    
                }
            } catch {
                DispatchQueue.main.async {
                    self?.errorMessage = "Failed to decode response: \(error.localizedDescription)"
                }
            }
            DispatchQueue.main.async {
                self?.isLoaded = true
            }
        }.resume()
    }
    func loadImage(from url: String) -> UIImage? {
        // Check if the image is already cached
        if let cachedImage = imageCache.getImage(forKey: url) {
            return cachedImage
        }
        
        // If not, download the image and cache it
        if let imageUrl = URL(string: url), let imageData = try? Data(contentsOf: imageUrl), let image = UIImage(data: imageData) {
            imageCache.storeImage(image, forKey: url)
            return image
        }
        
        return nil
    }
}



