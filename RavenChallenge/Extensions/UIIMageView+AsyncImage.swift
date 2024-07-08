//
//  UIIMageView+AsyncImage.swift
//  RavenChallenge
//
//  Created by Dardo Matias Mansilla on 06/07/2024.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()
let imageDownloadTasks = NSMapTable<UIImageView, URLSessionDataTask>(keyOptions: .weakMemory, valueOptions: .strongMemory)

extension UIImageView {
    
    func loadImageUsingCache(withUrl urlString: String, placeholder: UIImage?, completion: ((Data?) -> Void)? = nil) {
        
        // Cancel previous task if any
        if let previousTask = imageDownloadTasks.object(forKey: self) {
            previousTask.cancel()
        }
        
        let url = URL(string: urlString)
        self.image = placeholder
        
        // Check cached image
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            self.image = cachedImage
            completion?(cachedImage.pngData())
            return
        }
        
        // If not, download image from URL
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if let error = error {
                print("Failed to load image: \(error)")
                DispatchQueue.main.async {
                    completion?(nil)
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Failed to load image: invalid HTTP response")
                DispatchQueue.main.async {
                    completion?(nil)
                }
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                print("Failed to load image: data or image is nil")
                DispatchQueue.main.async {
                    completion?(nil)
                }
                return
            }
            
            DispatchQueue.main.async {
                imageCache.setObject(image, forKey: urlString as NSString)
                self.image = image
                completion?(data)
            }
        }
        
        // Store task in map table
        imageDownloadTasks.setObject(task, forKey: self)
        task.resume()
    }
}
