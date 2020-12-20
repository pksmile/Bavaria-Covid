//
//  MapViewController.swift
//  BavariaCovid
//
//  Created by PRAKASH on 12/18/20.
//

import UIKit
import MapKit
import UserNotifications
import CoreLocation

class MapVC: UIViewController {
    var locationPresenter : LocationPresenter?
    var presenter: MapViewToPresenterProtocol?
    var mapInteractor  = ""
    var case7per100: Float = 0.0
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let presenterLocal: MapViewToPresenterProtocol & MapInteractorToPresenterProtocol = MapPresenter()
        let interactor: MapPresentorToInteractorProtocol = MapInteractor()
        let router: MapPresenterToRouterProtocol = MapRouter()
        
        
        presenterLocal.view = self
        presenterLocal.router = router
        presenterLocal.interactor = interactor
        interactor.presenter = presenterLocal
        
        self.presenter = presenterLocal
        // Do any additional setup after loading the view.
        mapView.delegate = self
        presenter?.updateView()
        
        
        
        if locationPresenter    ==  nil{
            locationPresenter   =   LocationPresenter(viewC: self)
        }
        locationPresenter?.checkUsersLocationServicesAuthorization()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if locationPresenter    ==  nil{
            locationPresenter   =   LocationPresenter(viewC: self)
        }
        locationPresenter?.checkUsersLocationServicesAuthorization()
    }
    
    
}

extension MapVC : MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
       if let routePolyline = overlay as? MKPolygon {
            let renderer = MKPolygonRenderer(overlay: routePolyline)
            switch case7per100 {
            case 0..<35:
                renderer.fillColor = UIColor.kGreen
            case 36..<50:
                renderer.fillColor = UIColor.kYellow
            case 51..<100:
                renderer.fillColor = UIColor.kRed
            default:
                renderer.fillColor = UIColor.kDarkRed
            }
            return renderer
        }
        return MKOverlayRenderer()
    }
}



// MARK: - LiveNewsListPresenterToViewProtocol
extension MapVC: MapPresenterToViewProtocol {

    func drawColorsOnMap(){
        let overlays = mapView.overlays
        if overlays.count > 0 {
            mapView.removeOverlays(overlays)
        }
        
        presenter?.allFeatures()?.forEach { (feature) in
            self.drawOverlay(feature: feature)
            self.checkUserState(feature: feature)
        }
    }
    
    func drawOverlay(feature : FeatureModel){
        let locationCoordinates: [CLLocationCoordinate2D] = feature.toCoordinates()
        
        if locationCoordinates.count > 0{
            case7per100 = feature.attributes?.cases7_per_100k ?? 0
            let polygons = MKPolygon(coordinates: locationCoordinates, count: locationCoordinates.count)
            mapView.addOverlay(polygons)
        }
    }
    
    func showError() {
        AlertControl().showAlert(title: "Error", message: "Can Not fetch data from server.", viewController: self, okButtonTitle: "Okay")
    }
    
    func onLocationChange() {
        presenter?.allFeatures()?.forEach({ (feature) in
            checkUserState(feature: feature)
        })
    }
    
    func checkUserState(feature: FeatureModel) {
        let locationCoordinates: [CLLocationCoordinate2D] = feature.toCoordinates()
        let polygons = MKPolygon(coordinates: locationCoordinates, count: locationCoordinates.count)
        let polygonRenderer = MKPolygonRenderer(polygon: polygons)
        let mapPoint: MKMapPoint = MKMapPoint((locationPresenter?.currentUserLocation.coordinate)!)
        let polygonViewPoint: CGPoint = polygonRenderer.point(for: mapPoint)

        if polygonRenderer.path.contains(polygonViewPoint)
        {
            switch feature.attributes!.cases7_per_100k {
            case 0..<35:
                UNUserNotificationCenter.sendCovideAlertMsg(title: "Bavaria Covid", message: rules.green.rawValue)
            case 36..<50:
                UNUserNotificationCenter.sendCovideAlertMsg(title: "Bavaria Covid", message: rules.yellow.rawValue)
            case 51..<100:
                UNUserNotificationCenter.sendCovideAlertMsg(title: "Bavaria Covid", message: rules.red.rawValue)
            default:
                UNUserNotificationCenter.sendCovideAlertMsg(title: "Bavaria Covid", message: rules.darkGreen.rawValue)
            }
            print("Your location was inside your polygon.\(String(describing: feature.attributes?.cases7_per_100k))")
            
        }else{
            print("Not in Polygonn")
        }
    }
}

