//
//  Extensions.swift
//  ChattingApplication
//
//  Created by XINHAO LI on 4/6/17.
//  Copyright © 2017 XINHAO LI. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    func loadImageUSingCacheWithUrlString(urlString: String) {
        self.image = nil
        // check cach for image first
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        
        
        let url = URL(string: urlString)
        
        URLSession.shared.dataTask(with: url! as URL, completionHandler: { (data, response, error) in
            
            //download hit an error so lets return out
            if error != nil {
                print(error)
                return
            }
            
            DispatchQueue.main.async(execute: {
                if let lownloadedImage = UIImage(data: data!) {
                    imageCache.setObject(lownloadedImage, forKey: urlString as AnyObject)
                    self.image = lownloadedImage
                }
                
                
            })
            
        }).resume()
    }
}
