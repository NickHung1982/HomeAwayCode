//
//  Helper.swift
//  HomeAwayCode
//
//  Created by Nick on 9/28/19.
//  Copyright © 2019 NickOwn. All rights reserved.
//

import Foundation

class Helper {
    
    static func transferDateString(_ orgDateStr: String) -> String {
        //time format
        let dateFormatterGet = DateFormatter()
        //2019-07-19T00:00:00
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let date: Date? = dateFormatterGet.date(from: orgDateStr)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm a"
        return dateFormatter.string(from: date!)
    }
    
    static func readFavList() -> [String]? {
        if let path = Bundle.main.path(forResource: "data", ofType: "plist"),
            let listfileWithPath = FileManager.default.contents(atPath: path),
            let preferences = try? PropertyListDecoder().decode(Preferences.self, from: listfileWithPath)
        {
            return preferences.savedFav
        }
        return nil
    }
    
    static func removeFavID(_ id: String ) -> Bool {
        if let fileUrl = Bundle.main.url(forResource: "data", withExtension: "plist"),
            let initdata = try? Data(contentsOf: fileUrl),
            let preferences = try? PropertyListDecoder().decode(Preferences.self, from: initdata)
        {
            
            var newValueForList = preferences
            var newStringArray = [String]()
            for li in newValueForList.savedFav {
                if li != id {
                    newStringArray.append(li)
                }
            }
            newValueForList.savedFav = newStringArray
            
            let encoder = PropertyListEncoder()
            encoder.outputFormat = .xml
            
            do {
                let data = try encoder.encode(newValueForList)
                try data.write(to: fileUrl)
                return true
            } catch {
                return false
            }
            
            
        }
        return false
    }
    
    static func addFavID(_ id: String ) -> Bool {
        
        if let fileUrl = Bundle.main.url(forResource: "data", withExtension: "plist"),let initdata = try? Data(contentsOf: fileUrl), let preferences = try? PropertyListDecoder().decode(Preferences.self, from: initdata)
        {
            
            var newValueForList = preferences
            newValueForList.savedFav.append(id)
            
            let encoder = PropertyListEncoder()
            encoder.outputFormat = .xml
            
            do {
                let data = try encoder.encode(newValueForList)
                try data.write(to: fileUrl)
                return true
            } catch {
                return false
            }
            
            
        }
        return false
    }
}
