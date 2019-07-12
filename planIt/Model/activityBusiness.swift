//
//  activityBusiness.swift
//  planIt
//
//  Created by Tracy Chen on 5/16/19.
//  Copyright © 2019 Tracy. All rights reserved.
//

import Foundation
import ObjectMapper

class activityBusiness: Mappable {
    
    var businesses: [Activity]
    
    required init?(map: Map) {
        self.businesses = []
    }
    
    func mapping(map: Map) {
        businesses  <- map["businesses"]
    }
    
    init(businesses: [Activity]) {
        self.businesses = businesses
    }
    
}
