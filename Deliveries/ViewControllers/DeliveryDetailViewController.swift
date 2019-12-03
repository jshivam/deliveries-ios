//
//  DeliveryDetailViewController.swift
//  Deliveries
//
//  Created by Shivam Jaiswal on 08/11/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import UIKit
import MapKit

class DeliveryDetailViewController: BaseViewController {

    private struct Constants {
        static let markerIdentifier = "annotation"
        static let title = LocalizedConstants.deliveryDetailTitle
        static let routeVisibilityArea: Double = 3000
    }

    let viewModel: DeliveryDetailViewModelProtocol
    let mapView: MKMapView = {
        let mapView = MKMapView(frame: .zero)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()

    private let deliveryView: DeliveryView = {
       let view = DeliveryView()
       view.translatesAutoresizingMaskIntoConstraints = false
       return view
    }()

    private let blurView: UIVisualEffectView = {
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .prominent))
        blurView.translatesAutoresizingMaskIntoConstraints = false
        return blurView
    }()

    init(viewModel: DeliveryDetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never

        title = Constants.title
        mapView.delegate = self
        setup()
    }

    private func setup() {
        view.addSubview(mapView)
        view.addSubview(blurView)
        view.addSubview(deliveryView)

        deliveryView.update(text: viewModel.deliveryDescribtion, imageUrl: viewModel.imageURL)
        deliveryView.dropShadow()

        addConstraints()
        dropDestinationPin()
    }

    private func addConstraints() {
        deliveryView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        deliveryView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        deliveryView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true

        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        mapView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        blurView.topAnchor.constraint(equalTo: deliveryView.topAnchor).isActive = true
        blurView.leftAnchor.constraint(equalTo: deliveryView.leftAnchor).isActive = true
        blurView.rightAnchor.constraint(equalTo: deliveryView.rightAnchor).isActive = true
        blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    private func dropDestinationPin() {
        if let destinationLocation = viewModel.coordinate2D, let annotation = viewModel.annotation {
            mapView.addAnnotation(annotation)
            let viewRegion = MKCoordinateRegion(center: destinationLocation,
                                                latitudinalMeters: Constants.routeVisibilityArea,
                                                longitudinalMeters: Constants.routeVisibilityArea)
            mapView.setRegion(viewRegion, animated: true)
        }
    }
}

extension DeliveryDetailViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }

        let identifier = Constants.markerIdentifier
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }

        return annotationView
    }
}
