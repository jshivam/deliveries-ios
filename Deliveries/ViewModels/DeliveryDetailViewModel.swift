//
//  DeliveryDetailViewModel.swift
//  Deliveries
//
//  Created by Shivam Jaiswal on 08/11/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import MapKit

protocol DeliveryDetailViewModelProtocol {
    init(delivery: DeliveryCoreDataModel)
    var deliveryDescribtion: String? { get }
    var imageURL: String? { get }
    var coordinate2D: CLLocationCoordinate2D? { get }
    var annotation: MKPointAnnotation? { get }
}

class DeliveryDetailViewModel: DeliveryDetailViewModelProtocol {
    private let delivery: DeliveryCoreDataModel

    required init(delivery: DeliveryCoreDataModel) {
        self.delivery = delivery
    }

    var deliveryDescribtion: String? {
        return "\(delivery.desc ?? LocalizedConstants.unnamed) at \(delivery.location?.address ?? LocalizedConstants.unnamed)"
    }

    var imageURL: String? {
        return delivery.imageUrl
    }

    var coordinate2D: CLLocationCoordinate2D? {
        guard let location = delivery.location else { return nil }
        let destinationLocation = CLLocationCoordinate2D(latitude: location.lat, longitude: location.lng)
        return destinationLocation
    }

    var annotation: MKPointAnnotation? {
        guard let destinationLocation = coordinate2D, let address = delivery.location?.address else { return nil }
        let annotation = MKPointAnnotation()
        annotation.title = address
        annotation.coordinate = destinationLocation
        return annotation
    }
}
