//
//  LocationPresenter.swift
//  BavariaCovid
//
//  Created by PRAKASH on 12/18/20.
//

import MapKit

class LocationPresenter: NSObject, CLLocationManagerDelegate {
    var viewController : UIViewController!
    var locationManager: CLLocationManager!
    var lastUserLocation: CLLocation!
    let regionRadius: CLLocationDistance = 1000
    var currentUserLocation: CLLocation = CLLocation()
    
    init(viewC : UIViewController) {
        self.viewController = viewC
    }
    
    func checkUsersLocationServicesAuthorization(){
        // Check if user has authorized Total Plus to use Location Services
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            switch locationManager.authorizationStatus {
            case .notDetermined:
                locationManager.requestAlwaysAuthorization()
                break
                
            case .restricted, .denied:
                self.showLocationAlert()
                break
            case .authorizedWhenInUse, .authorizedAlways:
                break
            @unknown default:
                self.showLocationAlert()
            }
            
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        else {
            self.showLocationAlert()
        }
    }
    
    func showLocationAlert(){
        AlertControl().showLocationAlertOn(viewController: self.viewController)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentUserLocation = locations[0] as CLLocation
        
        let center = CLLocationCoordinate2D(latitude: currentUserLocation.coordinate.latitude, longitude: currentUserLocation.coordinate.longitude)
        let mRegion = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 8, longitudeDelta: 8))
        let artwork = Artwork(title: "Your Location", coordinate: currentUserLocation.coordinate)

        if let mapVC : MapVC = self.viewController as? MapVC{
            let annotations: [MKAnnotation] = mapVC.mapView.annotations
            if annotations.count > 0 {
                mapVC.mapView.removeAnnotations(annotations)
            }
            mapVC.mapView.addAnnotation(artwork)
            mapVC.mapView.setRegion(mRegion, animated: true)
            
            if lastUserLocation == nil {
                lastUserLocation = currentUserLocation
            }
            
            if lastUserLocation != currentUserLocation {
                lastUserLocation = currentUserLocation
                mapVC.onLocationChange()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error - locationManager: \(error.localizedDescription)")
    }
}
