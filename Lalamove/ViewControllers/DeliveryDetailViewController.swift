//
//  DeliveryDetailViewController.swift
//  Lalamove
//
//  Created by Shivam Jaiswal on 01/11/19.
//  Copyright © 2019 Shivam Jaiswal. All rights reserved.
//

import UIKit
import MapKit

struct MapConstants {
    static let routeVisibilityArea: Double = 3000
    static let routeLineWidth: CGFloat = 5.0
    static let markerIdentifier = "marker"
    static let routeFrameExtraMargin: Double = 6000
    static let routeOriginExtraMargin: Double = 3000
    static let routeColor: UIColor = .red
}

class DeliveryDetailViewController: UIViewController {

    let viewModel: DeliveryDetailViewModel
    let mapView: MKMapView = {
        let mapView = MKMapView(frame: .zero)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    let nameLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor.darkText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let profileImageView:UIImageView = {
        let img = UIImageView()
        img.backgroundColor = .darkGray
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        img.layer.cornerRadius = Constants.defautlCornerRadius
        img.clipsToBounds = true
       return img
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
        title = "Delivery Details"
        mapView.delegate = self
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = .white
        view.addSubview(mapView)
        view.addSubview(profileImageView)
        view.addSubview(nameLabel)
        
        if let imageUrl = viewModel.delivery.imageUrl, let url = URL.init(string: imageUrl) {
            profileImageView.af_setImage(
                withURL: url,
                placeholderImage: nil,
                filter: nil,
                imageTransition: .crossDissolve(0.2)
            )
        }
        
        nameLabel.text = viewModel.delivery.desc
        addConstraints()
        dropDestinationPin()
    }

    func addConstraints() {
        let views: [String: Any] = [
            "mapView": mapView,
            "destinationImageView": profileImageView,
            "destinationLabel": nameLabel]

        var allConstraints: [NSLayoutConstraint] = []

        let mapHorizontalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[mapView]|",
            metrics: nil,
            views: views)
        allConstraints += mapHorizontalConstraints

        let bottomViewHorizontalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[destinationImageView(80)]-10-[destinationLabel]-10-|",
            metrics: nil,
            views: views)
        allConstraints += bottomViewHorizontalConstraints

        let imageVerticalConstraint = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[mapView]-10-[destinationImageView(80)]-50-|",
            metrics: nil,
            views: views)
        allConstraints += imageVerticalConstraint

        let labelVerticalConstraint = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[mapView]-10-[destinationLabel]-50-|",
            metrics: nil,
            views: views)
        allConstraints += labelVerticalConstraint

        view.addConstraints(allConstraints)

    }
}

extension DeliveryDetailViewController: MKMapViewDelegate {
    
    func dropDestinationPin()
    {
        if let location = viewModel.delivery.location {
            let destinationLocation = CLLocationCoordinate2D(latitude: location.lat, longitude: location.lng)
            let annotation = MKPointAnnotation()
            annotation.title = location.address
            annotation.coordinate = destinationLocation
            mapView.addAnnotation(annotation)
            let viewRegion = MKCoordinateRegion(center: destinationLocation, latitudinalMeters: MapConstants.routeVisibilityArea, longitudinalMeters: MapConstants.routeVisibilityArea)
            mapView.setRegion(viewRegion, animated: true)
        }
    }

    // MARK: MKMapView delegate methods
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polineLineRenderer = MKPolylineRenderer(overlay: overlay)
        polineLineRenderer.strokeColor = MapConstants.routeColor
        polineLineRenderer.lineWidth = MapConstants.routeLineWidth
        return polineLineRenderer
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }

        let identifier = "Annotation"
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
