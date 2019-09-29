//
//  MainViewModel.swift
//  HomeAwayCode
//
//  Created by Nick on 9/28/19.
//  Copyright © 2019 NickOwn. All rights reserved.
//

import Foundation
import UIKit

final class MainViewModel: NSObject {
    //loading status flag
    let isLoading = Observable<Bool>(value: false)
    //table view hidden flag
    let isTableViewHidden = Observable<Bool>(value: false)
    //stored object array
    let eventList = Observable<[EventItem]>(value: [])
    //fav list
    var favList = Helper.readFavList()
    //navi bar title
    let title = Observable<String>(value: "")
    //data service
    let service = DataNetWorking<Source>()
    
    var sourceType: Source
    init(Source: Source) {
        self.sourceType = Source
        super.init()
    }
    
}


extension MainViewModel {
    
    //First loading
    internal func start() {
        self.isLoading.value = true
        self.title.value = self.sourceType.pathName
        service.request(ep: self.sourceType, completion: { data, res, err in
            self.isLoading.value = false
            self.isTableViewHidden.value = false
            if let data = data {
                do{
                    let decoder = JSONDecoder()
                    let jsonData = try decoder.decode(JsonData.self, from: data)
                    
                    if jsonData.events.count > 0 {
                        self.eventList.value = self.markedFavInList(jsonData.events)
                    }
                }catch let JSONError {
                    print("\(JSONError)")
                }
    
            }
            
        })
    }
    //When user change click change source
    internal func changeSource(source: Source) {

        self.isTableViewHidden.value = true
        self.title.value = self.sourceType.pathName
        self.isLoading.value = true
        self.sourceType = source
        service.request(ep: source, completion: { data, res, err in
            self.isLoading.value = false
            self.title.value = source.pathName
            self.isTableViewHidden.value = false
            if let data = data {
                do{
                    let decoder = JSONDecoder()
                    let jsonData = try decoder.decode(JsonData.self, from: data)
                    
                    if jsonData.events.count > 0 {
                        self.eventList.value = self.markedFavInList(jsonData.events)
                    }
                }catch let JSONError {
                    print("\(JSONError)")
                }
            }
        })
    }
    //get image from server or cache
    internal func getImage(withURL url:URL, completion:@escaping(_ image:UIImage?) -> ()) {
        service.getImageFromLink(withURL: url, completion: { img in
            completion(img)
        })
    }
    //when fav list change, change eventItem's is_open value
    internal func rebindDataWithFav() {
        self.favList = Helper.readFavList()
        self.eventList.value = self.markedFavInList(self.eventList.value)
    }
    
    //Compare with savedFav from plist
    private func markedFavInList(_ orgList: [EventItem]) -> [EventItem] {
        //fav is empty, nothing to compare
        guard let favlist = self.favList else {
            return orgList
        }
        
        var newList = orgList
        let favSet = Set(favlist)
        for i in 0..<newList.count {
            if favSet.contains(String(newList[i].id)) {
                newList[i].is_open = true
            }else{
                newList[i].is_open = false
            }
        }
        
        return newList
    }
}
