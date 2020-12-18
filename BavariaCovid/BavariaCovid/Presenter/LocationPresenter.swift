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
        currentUserLocation = CLLocation.init(latitude: 52.520008, longitude: 13.404954)//locations[0] as CLLocation
        
        let center = CLLocationCoordinate2D(latitude: currentUserLocation.coordinate.latitude, longitude: currentUserLocation.coordinate.longitude)
        let mRegion = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        let artwork = Artwork(title: "Your Location", coordinate: currentUserLocation.coordinate)
        
        if let mapVC : MapVC = self.viewController as? MapVC{
            mapVC.mapView.addAnnotation(artwork)
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: currentUserLocation.coordinate.latitude, longitude: currentUserLocation.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
            mapVC.mapView.setRegion(region, animated: true)
            //                        let _ = Artwork(title: "Your Location", coordinate: currentUserLocation.coordinate)
            //
            //            mapVC.mapView.setRegion(mRegion, animated: true)
        }
        
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error - locationManager: \(error.localizedDescription)")
    }
}
