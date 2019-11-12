//
//  JSONLoader.swift
//  DeliveriesTests
//
//  Created by Shivam Jaiswal on 11/11/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

@testable import Deliveries
import Foundation

class JSONLoader {
    class func jsonFileToDict(jsonName: String) -> [String: AnyObject]? {
        if let path = Bundle(for: JSONLoader.self).path(forResource: jsonName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? [String: AnyObject] {
                    return jsonResult
                }
            } catch {
                return nil
            }
        }
        return nil
    }

    class func jsonFileToData(jsonName: String) -> Data? {

        if let path = Bundle(for: JSONLoader.self).path(forResource: jsonName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                return data
            } catch {
                return nil
            }
        }
        return nil
    }

    class func getDeliveries() -> [Delivery] {
        let data = jsonFileToData(jsonName: "deliveries")
        do {
            let decoder = JSONDecoder()
            let deliveries = try decoder.decode([Delivery].self, from: data!)
            return deliveries
        } catch {

        }
        return []
    }

}
