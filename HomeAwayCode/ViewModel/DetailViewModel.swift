//
//  DetailViewModel.swift
//  HomeAwayCode
//
//  Created by Nick on 9/28/19.
//  Copyright © 2019 NickOwn. All rights reserved.
//

import Foundation
import UIKit

final class DetailViewModel: NSObject {
    let item: EventItem
    let service = DataNetWorking<Source>()
    var isFav: Bool
    
    init(item: EventItem) {
        self.item = item
        self.isFav = false
        if let favList = Helper.readFavList() {
            if favList.filter({ $0 == String(item.id) }).count > 0 {
                self.isFav = true
            }
        }
        super.init()
        
    }
    
    internal func getImage(withURL url:URL, completion:@escaping(_ image:UIImage?) -> ()) {
        service.getImageFromLink(withURL: url, completion: { img in
            completion(img)
        })
    }
}
