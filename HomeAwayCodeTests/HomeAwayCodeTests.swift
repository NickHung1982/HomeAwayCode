//
//  HomeAwayCodeTests.swift
//  HomeAwayCodeTests
//
//  Created by Nick on 9/28/19.
//  Copyright © 2019 NickOwn. All rights reserved.
//

import XCTest
@testable import HomeAwayCode

class HomeAwayCodeTests: XCTestCase {
    var item: EventItem!
    var mvm: MainViewModel!
    var dvm: DetailViewModel!
    
    override func setUp() {
        mvm = MainViewModel(Source: .All)
        let performer1 = Performers(image: nil, id:55)
        let performer2 = Performers(image: nil, id:56)
        let vanue = Venue(postal_code: "55688", city: "Brooklyn", display_location: "Brooklyn, NY")
        item = EventItem(id: 1234, title: "test", datetime_local: "2019-09-28T03:30:00", performers: [performer1,performer2], venue: vanue, is_open: false)
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testReadTokenFromPlist() {
        if let path = Bundle.main.path(forResource: "data", ofType: "plist"),
            let myDict = NSDictionary(contentsOfFile: path){
            if let tokenString = myDict["token"] as? String {
                XCTAssertEqual(tokenString, "MTg2MzU1Nzh8MTU2OTYyODU4OS41OA", "read token success")
            }
        }
    }

    func testReadAPILinkFromPlist() {
        if let path = Bundle.main.path(forResource: "data", ofType: "plist"),
            let myDict = NSDictionary(contentsOfFile: path){
            if let linkString = myDict["apilink"] as? String {
                XCTAssertEqual(linkString, "https://api.seatgeek.com/2/events", "read link success")
            }
        }
    }
    
    func testWriteFavIDToPlist(){
        guard let beforelist = Helper.readFavList() else {
            return
        }
        print(beforelist)
        
        _ = Helper.addFavID("123455")
        
        guard let afterlist = Helper.readFavList() else {
            return
        }
        print(afterlist)
        
        XCTAssertNotEqual(beforelist, afterlist)
        
        _ = Helper.removeFavID("123455")
    }
    
    func testReadFavFromPList(){
        if let path = Bundle.main.path(forResource: "data", ofType: "plist"),
            let listfileWithPath = FileManager.default.contents(atPath: path),
            let preferences = try? PropertyListDecoder().decode(Preferences.self, from: listfileWithPath)
        {
            
            print(preferences.savedFav)
           
            if preferences.savedFav.count > 0 {
                XCTAssertTrue(true, "there is value inside the list")
            }
            
        }
    }


    func testReadJSONfromMock() {
        let testBundle = Bundle(for: HomeAwayCodeTests.self)
        if let path = testBundle.path(forResource: "mock2", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                
                if let jsonstr = String(data: data, encoding: .utf8) {
                   print(jsonstr)
                }
                
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(JsonData.self, from: data)
                
                if jsonData.events.count > 0 {
                    XCTAssertTrue(true, "read mock data success")
                }
            } catch let jsonErr {
                print("error:\(jsonErr)")
            }
        }
        
        
    }
    
   //fetch data
    func testNetWorkService()  {
        let service = DataNetWorking<Source>()
        service.request(ep: Source.Sporting, completion: { data, res, err in
           
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let jsonData = try decoder.decode(JsonData.self, from: data)
                    
                    if jsonData.events.count > 0 {
                        XCTAssertTrue(true, "read mock data success")
                    }
                    
                }
                catch let JSONError {
                    print("\(JSONError)")
                }
            }
            
        })
      

    }

    //ViewModel test
    func testMainViewModelInit() {
        // title should be all events
        let mvm = MainViewModel(Source: .Sporting)
        XCTAssertEqual(mvm.sourceType.pathName, "Sporting")
        
    }
    
   
}
