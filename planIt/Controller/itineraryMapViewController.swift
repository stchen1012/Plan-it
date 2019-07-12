//
//  itineraryMapViewController.swift
//  planIt
//
//  Created by Tracy Chen on 5/18/19.
//  Copyright © 2019 Tracy. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class itineraryMapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var itineraryMap: MKMapView!
    @IBAction func onMapBackTap(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    var locationManager = CLLocationManager()
    var businessCoordinates:[Activity] = []
    var distanceInMeters:Double = 0
    var arrayForCoordinateDistancesCompare:[Double] = []
    var greatestDistance = 0.0
    var selectedAnnotation: MKPointAnnotation?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itineraryMap.delegate = self
        checkLocationServices()
        
        for i in businessCoordinates {
            var pointAnnotation = MKPointAnnotation()
            pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: i.latitude ?? 0.0, longitude: i.longitude ?? 0.0)
            pointAnnotation.title = i.name
            //print("FROM MAPVIEW: \(pointAnnotation.title)")
            //pointAnnotation.subtitle = "This is where i am"
            itineraryMap.addAnnotation(pointAnnotation)
            let userCurrentCoordinates = CLLocation (latitude: locationManager.location?.coordinate.latitude ?? 0.0, longitude: locationManager.location?.coordinate.longitude ?? 0.0)
            let activityObjectCoordinates = CLLocation (latitude: i.latitude ?? 0.0, longitude: i.longitude ?? 0.0)
            distanceInMeters = userCurrentCoordinates.distance(from: activityObjectCoordinates)
            arrayForCoordinateDistancesCompare.append(distanceInMeters)
            print("THIS IS MY ARRAYOFDISTANCE: \(arrayForCoordinateDistancesCompare)")
        }
        
        greatestDistance = arrayForCoordinateDistancesCompare.max() ?? 0.0
        print("This is my greatest distance: \(greatestDistance)")
    }
        /* //come back to this code when ready to implement directions functionality
        let request = MKDirections.Request()
        
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: locationManager.location?.coordinate.latitude ?? 0.0, longitude: locationManager.location?.coordinate.longitude ?? 0.0), addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: selectedAnnotation?.coordinate.latitude ?? 0.0, longitude: selectedAnnotation?.coordinate.longitude ?? 0.0), addressDictionary: nil))
        request.requestsAlternateRoutes = true
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        
        directions.calculate {
            (response, error) -> Void in
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                return
            }
            
            if !response.routes.isEmpty {
                let route = response.routes[0]
                DispatchQueue.main.async { [weak self] in
                    self?.itineraryMap.addOverlay(route.polyline)
                }
            }
        }
    }
 */
        /*
        locationManager = CLLocationManager()
        locationManager!.requestAlwaysAuthorization() //this always prompts user
        //locationManager!.requestWhenInUseAuthorization()
        locationManager?.delegate = self
        itineraryMap.delegate = self
        
        //self.view.layer.masksToBounds = true
        itineraryMap.layer.cornerRadius = 10
        itineraryMap.layer.masksToBounds = true
        itineraryMap.showsUserLocation = true
        locationManager?.startUpdatingLocation()
        print(locationManager!)
        
        itineraryMap.setCenter(locationManager!.location!.coordinate, animated: true)
        itineraryMap.isZoomEnabled = true
        //        var distance = CLLocationDistance.distance()  if you find the max distance, use this
        let region = MKCoordinateRegion(center: locationManager!.location!.coordinate, latitudinalMeters: CLLocationDistance(exactly: 5000)!, longitudinalMeters: CLLocationDistance(exactly: 5000)!)
        itineraryMap.setRegion(region, animated: false)

        
        
        // Loop through your activities array and add each annotation, one by one, setting the title and subtitle
     
        var pointAnnotation = MKPointAnnotation.init()
        pointAnnotation.coordinate = locationManager!.location!.coordinate
        pointAnnotation.title = "Tracy location!"
        pointAnnotation.subtitle = "This is where i am"
//
        itineraryMap.addAnnotation(pointAnnotation)

    */

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
    
//    // this function is for directional line
//    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
//        renderer.strokeColor = UIColor.blue
//        return renderer
//    }
// //this is for getting coordinates for selected annotation for directions functionality
//    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//        var selectedAnnotation = view.annotation
//    }

    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: greatestDistance * 2.1, longitudinalMeters: greatestDistance * 2.1)
            itineraryMap.setRegion(region, animated: true)
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
            itineraryMap.showsUserLocation = true
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

extension itineraryMapViewController: CLLocationManagerDelegate {
        
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return}
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: greatestDistance * 2, longitudinalMeters: greatestDistance * 2)
        itineraryMap.setRegion(region, animated: true)
    }
        
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            checkLocationAuthorization()
    }
}


/*
 //    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
 //
 //    }
 
 
 
 //    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
 //        switch status {
 //        case .notDetermined:
 //            manager.requestLocation()
 //        case .authorizedAlways, .authorizedWhenInUse:
 //            //MAKE SURE THIS EXECUTES AFTER USER HAS AUTHORIZED LOCATION -- RESTRUCTURE CODE // didChangeAuhtorization status - check BT code on slack
 //            //the below code centers the location pin on map
 //
 //            itineraryMap.setCenter(locationManager!.location!.coordinate, animated: true)
 //            itineraryMap.isZoomEnabled = true
 //            //        var distance = CLLocationDistance.distance()  if you find the max distance, use this
 //            let region = MKCoordinateRegion(center: locationManager!.location!.coordinate, latitudinalMeters: CLLocationDistance(exactly: 5000)!, longitudinalMeters: CLLocationDistance(exactly: 5000)!)
 //            itineraryMap.setRegion(region, animated: false)
 //        default: break
 // Permission denied, do something else
 // delete break after testing
 }
 */
