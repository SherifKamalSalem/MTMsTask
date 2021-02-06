//
//  MTMRequest.swift
//  MTMsTask
//
//  Created by sherif kamal on 06/02/2021.
//

import Foundation

struct MTMRequest {
    var clientName: String?
    var clientPhoto: String?
    var destinationLatitude: Double?
    var destinationLongitude: Double?
    var drivers: [MTMDriver]?
    var requestDate: String?
    var sourceLatitude: Double?
    var sourceLongitude: Double?

    init() {
        
    }
}
