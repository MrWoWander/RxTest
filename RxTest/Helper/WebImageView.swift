//
//  WebImageView.swift
//  RxTest
//
//  Created by Mikhail Ivanov on 20.10.2021.
//

import UIKit

class WebImageView: UIImageView {
    
    func set(imageURL: String?, complited: (() -> Void)? = nil) {
        
        guard let imageURL = imageURL,
              let url = URL(string: imageURL)
        else {
            self.image = nil
            return
        }
        
        
        if let cacheResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)) {
            self.image = UIImage(data: cacheResponse.data)
            DispatchQueue.main.async {
                complited?()
            }
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if let data = data,
                   let response = response {
                    self?.image = UIImage(data: data)
                    
                    self?.handelLoadImage(data: data, response: response)
                    complited?()
                }
            }
        }
        
        task.resume()
    }
    
    private func handelLoadImage(data: Data, response: URLResponse) {
        guard let responseURL = response.url else { return }
        
        let cacheResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cacheResponse, for: URLRequest(url:responseURL))
    }
}
