//
//  itinerary.swift
//  planIt
//
//  Created by Tracy Chen on 5/3/19.
//  Copyright © 2019 Tracy. All rights reserved.
//

import Foundation
import ObjectMapper

class Itinerary: Mappable {
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        leavingFrom <- map["leavingFrom"]
        travellingTo <- map["travellingTo"]
        leavingDate <- map["leavingDate"]
        travellingDates <- map["travellingDates"]
        //weatherAt <- map["weatherAt"]
        activitiesArray <- map["activitiesArray"]
        numberOfDays <- map["Number of Days"]
    }
    
    
    var leavingFrom: String? = ""
    var travellingTo: String? = ""
    var leavingDate: Date? = nil
    var travellingDates: String? = ""
    //var weatherAt: Double = 0.0
    var activitiesArray:[Activity] = []
    var numberOfDays: String? = ""
    
    init(leavingFrom: String?, travellingTo: String?, leavingDate: Date, travellingDates: String?, activitiesArray:[Activity], numberOfDays: String?) {
        
        self.leavingFrom = leavingFrom
        self.travellingTo = travellingTo
        self.leavingDate = leavingDate
        self.travellingDates = travellingDates
        //self.weatherAt = weatherAt
        self.activitiesArray = activitiesArray
        self.numberOfDays = numberOfDays
        
    }
    
    

}
