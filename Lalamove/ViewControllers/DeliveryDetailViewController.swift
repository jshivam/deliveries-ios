//
//  DeliveryDetailViewController.swift
//  Lalamove
//
//  Created by Shivam Jaiswal on 01/11/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import UIKit
import MapKit

class DeliveryDetailViewController: UIViewController {

    struct Constants {
        static let markerIdentifier = "annotation"
        static let title = "deliveryDetailTitle".localized()
        static let routeVisibilityArea: Double = 3000
    }

    let viewModel: DeliveryDetailViewModel
    let mapView: MKMapView = {
        let mapView = MKMapView(frame: .zero)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()

    let deliveryView: DeliveryView = {
       let view = DeliveryView()
       view.translatesAutoresizingMaskIntoConstraints = false
       return view
    }()

    init(viewModel: DeliveryDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = Constants.title
        mapView.delegate = self
        setup()
    }

    func setup() {
        view.backgroundColor = .white
        view.addSubview(mapView)
        view.addSubview(deliveryView)

        deliveryView.update(text: viewModel.delivery.desc, imageUrl: viewModel.delivery.imageUrl)
        addConstraints()
        dropDestinationPin()
    }

    func addConstraints() {
        deliveryView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        deliveryView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        deliveryView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        mapView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: deliveryView.topAnchor).isActive = true
    }

    func dropDestinationPin() {
        if let location = viewModel.delivery.location {
            let destinationLocation = CLLocationCoordinate2D(latitude: location.lat, longitude: location.lng)
            let annotation = MKPointAnnotation()
            annotation.title = location.address
            annotation.coordinate = destinationLocation
            mapView.addAnnotation(annotation)
            let viewRegion = MKCoordinateRegion(center: destinationLocation, latitudinalMeters: Constants.routeVisibilityArea, longitudinalMeters: Constants.routeVisibilityArea)
            mapView.setRegion(viewRegion, animated: true)
        }
    }
}
