//
//  EndPointType.swift
//  AppleRss
//
//  Created by Nick on 5/13/19.
//  Copyright © 2019 NickOwn. All rights reserved.
//

import Foundation

protocol EndPointType {
    var baseURL: URL { get }
    var pathName: String { get }
    var envir: Source { get }
}

public enum Source: String, CaseIterable {
    case Sporting,Monster_Truck,Sports_Concerts,All
    
}

extension Source : EndPointType {
    var baseURL: URL {
        guard let path = Bundle.main.path(forResource: "data", ofType: "plist"),
            let myDict = NSDictionary(contentsOfFile: path) else {
           fatalError("plist could not be reach.")
        }
        //get link
        guard let apilink = myDict["apilink"] as? String else {
            fatalError("apilink key could not be reach.")
        }
        //get token
        guard let tokenString = myDict["token"] as? String else {
            fatalError("tokencould not be reach.")
        }
        
        
        switch self {
        case .Sporting:
            return URL(string: apilink + "?client_id=" + tokenString + "&taxonomies.name=sports")!
        case .Monster_Truck:
            return URL(string: apilink + "?client_id=" + tokenString + "&taxonomies.name=monster_truck")!
        case .Sports_Concerts:
            return URL(string: apilink + "?client_id=" + tokenString + "&taxonomies.name=sports&taxonomies.name=concert")!
        default:
            return URL(string: apilink + "?client_id=" + tokenString)!
        }
    }
    
    var pathName: String {
        switch self {
        case .Sporting:
            return "Sporting"
        case .Monster_Truck:
            return "Monster Truck"
        case .Sports_Concerts:
            return "Sports Concerts"
        default:
            return "All events"
        }
    }
    
    var envir: Source {
        return self
    }
}


