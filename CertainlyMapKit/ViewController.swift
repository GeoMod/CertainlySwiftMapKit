//
//  ViewController.swift
//  CertainlyMapKit
//
//  Created by Daniel O'Leary on 9/5/19.
//  Copyright © 2019 Impulse Coupled Dev. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    
    let mnSizeNorthSouth = 579000.0
    let mnSizeEastWest = 579363.0
    let minnesotaGeoCenter = CLLocationCoordinate2D(latitude: 46.350262, longitude: -94.188733)
    
    // Apple Stores
    let rosedaleCenter = AppleStore(title: "Rosedale", coordinate: CLLocationCoordinate2D(latitude: 45.012917, longitude: -93.173026))
    let southdale = AppleStore(title: "Southdale", coordinate: CLLocationCoordinate2D(latitude: 44.880363, longitude: -93.324003))
    let ridgedale = AppleStore(title: "Ridgedale", coordinate: CLLocationCoordinate2D(latitude: 44.968736, longitude: -93.436142))
    let moa = AppleStore(title: "Mall of America", coordinate: CLLocationCoordinate2D(latitude: 44.853721, longitude: -93.241964))
    
    let locationManager = CLLocationManager()
    let geoCoder = CLGeocoder()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        
        let center = MKCoordinateRegion(center: minnesotaGeoCenter, latitudinalMeters: mnSizeNorthSouth, longitudinalMeters: mnSizeEastWest)
        mapView.setRegion(center, animated: true)
        mapView.showsUserLocation = true
        
        mapView.addAnnotations([rosedaleCenter, southdale, ridgedale, moa])
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is AppleStore else { return nil }
        
        let identifier = "AppleStore"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.animatesDrop = true
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
    
    
    // Get location from user entered string
    @IBAction func addAddress(_ sender: UIBarButtonItem) {
        let ac = UIAlertController(title: "Input Address", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Done", style: .default, handler: { address in
            guard let address = ac.textFields?[0].text else { return }
            self.showCustomMapLocation(at: address)
        }))
        present(ac, animated: true, completion: nil)
    }
    
    func showCustomMapLocation(at address: String) {
        geoCoder.geocodeAddressString(address) { (placeMarks, error) in
            guard let location = placeMarks?.first?.location else {
                print("No location found.")
                return }
            let annotation = AppleStore(title: "Favorite Location", coordinate: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
            
            self.mapView.addAnnotation(annotation)
            
            if let error = error {
                print("CLError Network: \(CLError.Code.network)")
                print("There was an \(error.localizedDescription).")
            }
        }
    }
}

