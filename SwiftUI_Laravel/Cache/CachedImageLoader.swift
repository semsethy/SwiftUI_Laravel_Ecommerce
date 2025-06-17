//
//  CachedImageLoader.swift
//  SwiftUI_Laravel
//
//  Created by JoshipTy on 4/5/25.
//


import SwiftUI
import Combine

class CachedImageLoader: ObservableObject {
    @Published var image: UIImage?
    private var cancellable: AnyCancellable?
    func load(from urlString: String) {
        if let cached = ImageCacheManager.shared.image(forKey: urlString) {
            self.image = cached
            return
        }
        guard let url = URL(string: urlString) else { return }
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] downloaded in
                guard let downloaded = downloaded else { return }
                ImageCacheManager.shared.set(downloaded, forKey: urlString)
                self?.image = downloaded
            }
    }
}
