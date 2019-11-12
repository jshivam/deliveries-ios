//
//  Address.swift
//  Deliveries
//
//  Created by Shivam Jaiswal on 08/11/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import Foundation

struct Delivery: Codable {
    let identifier: Int
    let desc: String
    let imageUrl: String
    let location: Location

    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case desc = "description" // used 'desc' as didn't want to use predefined key word 'description'
        case location
        case imageUrl
    }
}
