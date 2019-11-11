//
//  MockModel.swift
//  LalamoveTests
//
//  Created by Shivam Jaiswal on 05/11/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import UIKit

class MockModel: Codable {

    static var data: Data {
        let encoder = JSONEncoder()
        let data = try? encoder.encode(MockModel())
        return data!
    }
}
