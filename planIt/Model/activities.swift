//
//  activities.swift
//  planIt
//
//  Created by Tracy Chen on 5/3/19.
//  Copyright © 2019 Tracy. All rights reserved.
//

import Foundation
import ObjectMapper

class Activity: Mappable {
    
    var name: String?
    var image_url: String?
    var url: String?
    var latitude: Double?
    var longitude: Double?
    var display_address: Array<String>?
    var rating: Float?
    var coordinates:[String:Double] = [:]
    var displayAddressExtracted:String = ""
    var type = ""
    
    init(name: String, image_url: String, url: String, latitude: Double, longitude: Double, display_address: Array<String>?, rating: Float, coordinates:[String:Double], displayAddressExtracted:String, type:String) {
        
        self.name = name
        self.image_url = image_url
        self.url = url
        self.latitude = latitude
        self.longitude = longitude
        self.display_address = display_address
        self.rating = rating
        self.coordinates = coordinates
        self.displayAddressExtracted = displayAddressExtracted
        self.type = type
    }

    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        name         <- map["name"]
        image_url    <- map["image_url"]
        url  <- map["url"]
        latitude   <- map["coordinates.latitude"]
        longitude <- map["coordinates.longitude"]
        display_address <- map["location.display_address"]
        rating  <- map["rating"]
        coordinates <- map["coordinates"]
    }
    
    
    func parseAddress() -> String {
        var j = 0
        for i in display_address ?? [] {
            if j == 0 {
            displayAddressExtracted += "\(i)"
            j += 1
            } else {
                displayAddressExtracted += ", \(i)"
                j += 1
            }
        }
        return displayAddressExtracted
    }
    
}
