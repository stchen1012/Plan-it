//
//  user.swift
//  planIt
//
//  Created by Tracy Chen on 5/3/19.
//  Copyright © 2019 Tracy. All rights reserved.
//

import Foundation
import ObjectMapper

class User: Mappable {
    
    required init?(map: Map) {
        userID <- map["userID"]
        username <- map["username"]
        itineraryArray <- map["itineraryArray"]
    }
    
    func mapping(map: Map) {
        userID <- map["userID"]
        username <- map["username"]
        itineraryArray <- map["itineraryArray"]
    }
    
    var userID: String = ""
    var itineraryArray:[Itinerary] = []
    var username: String = ""
    
    /*
    func initializer(userID: String, username: String, itineraryArray:[Itinerary]) -> User {
        self.userID = userID
        self.username = username
        self.itineraryArray = itineraryArray
        return self
    }
 */
    
    init(userID: String, username: String, itineraryArray:[Itinerary]) {
        self.userID = userID
        self.username = username
        self.itineraryArray = itineraryArray
    }
}
