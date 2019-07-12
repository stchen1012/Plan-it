//
//  savedItineraryMapViewController.swift
//  planIt
//
//  Created by Tracy Chen on 6/15/19.
//  Copyright © 2019 Tracy. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class savedItineraryMapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var savedItineraryMapView: MKMapView!
    @IBAction func onBackTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    var locationManager = CLLocationManager()
    var individualItineraryInfoArray:[Itinerary] = []
    var distanceInMeters:Double = 0
    var arrayForCoordinateDistancesCompare:[Double] = []
    var greatestDistance = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        savedItineraryMapView.delegate = self
        checkLocationServices()

        for i in individualItineraryInfoArray[0].activitiesArray {
            var pointAnnotation = MKPointAnnotation()
            pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: i.latitude ?? 0.0, longitude: i.longitude ?? 0.0)
            pointAnnotation.title = i.name
            savedItineraryMapView.addAnnotation(pointAnnotation)
            let userCurrentCoordinates = CLLocation (latitude: locationManager.location?.coordinate.latitude ?? 0.0, longitude: locationManager.location?.coordinate.longitude ?? 0.0)
            let activityObjectCoordinates = CLLocation (latitude: i.latitude ?? 0.0, longitude: i.longitude ?? 0.0)
            distanceInMeters = userCurrentCoordinates.distance(from: activityObjectCoordinates)
            arrayForCoordinateDistancesCompare.append(distanceInMeters)
        }
        greatestDistance = arrayForCoordinateDistancesCompare.max() ?? 0.0
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
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: greatestDistance * 2.1, longitudinalMeters: greatestDistance * 2.1)
            savedItineraryMapView.setRegion(region, animated: true)
        }
    }
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // show alert letting the user know they have to turn this on
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            savedItineraryMapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            break
        case .denied:
            print("If you would like to use this feature, please allow location access in phone settings")
            break
        case . notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            //show alert
            break
        case .authorizedAlways:
            break
        }
    }
    
}

extension savedItineraryMapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return}
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: greatestDistance * 2, longitudinalMeters: greatestDistance * 2)
        savedItineraryMapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }

}
