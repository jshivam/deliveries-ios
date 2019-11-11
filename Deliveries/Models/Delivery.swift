//
//  Address.swift
//  Lalamove
//
//  Created by Shivam Jaiswal on 31/10/19.
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
        case desc = "description"
        case location
        case imageUrl
    }
}
