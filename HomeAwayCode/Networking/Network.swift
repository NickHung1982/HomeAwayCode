//
//  Network.swift
//
//
//  Created by Nick on 3/15/19.
//  Copyright © 2019 NickOwn. All rights reserved.
//

import Foundation
import UIKit

public typealias NetworkCompletion = (_ data: Data?,_ response: URLResponse?,_ error: Error?)->()

protocol NetworkingProtocol: class {
    associatedtype EndPoint: EndPointType
    
    //default call
    func request(ep: EndPoint, completion:@escaping NetworkCompletion)
    //get image from url, if cache has data, offer from cache
    func getImageFromLink(withURL url:URL, completion:@escaping(_ image:UIImage?) -> ())
}


class DataNetWorking<EndPoint: EndPointType>: NetworkingProtocol {
    //For cache image use
    private let cache = URLCache.shared
    internal func getImageFromLink(withURL url:URL, completion:@escaping(_ image:UIImage?) -> ()){
        let request = URLRequest(url: url)
        if let data = cache.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
            DispatchQueue.main.async {
                completion(image)
            }
        }else{
            //request from internet
            URLSession.shared.dataTask(with: url, completionHandler: { data, res, err in
                
                if let data = data , let res = res {
                    
                    let cachedData = CachedURLResponse(response: res, data: data)
                    self.cache.storeCachedResponse(cachedData, for: request)
                    
                    let image = UIImage(data: data)
                    
                    DispatchQueue.main.async {
                        completion(image)
                    }
                    
                }else{
                    completion(nil)
                }
                
            }).resume()
            
            
        }
        
    }
    
    internal func request(ep: EndPoint, completion:@escaping NetworkCompletion) {
        print(ep.baseURL)
        URLSession.shared.dataTask(with: ep.baseURL, completionHandler: { data, res, err in
            
            guard let httpResponse = res as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                self.handleError("Connection Fail!")
                return
            }
            
            DispatchQueue.main.async {
                completion(data, res, err)
            }
            
        }).resume()
        
        
    }
    //MARK:- PRIVATE METHODS
    //handle error with alertviewcontroll
    fileprivate func handleError(_ msg: String) {
        let alertVC = UIAlertController(title: "ERROR", message: msg, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertVC.addAction(ok)
        
        if var top = UIApplication.shared.keyWindow?.rootViewController {
            while let presentView = top.presentedViewController {
                top = presentView
            }
            top.present(alertVC, animated: true, completion: nil)
        }
    }
    
    
}
