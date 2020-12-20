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
    var previousLocation = CLLocation()
    var locationPresenter : LocationPresenter?
    var presenter: MapViewToPresenterProtocol?
    var mapInteractor  = ""
    var case7per100: Float = 0.0
    @IBOutlet weak var mapView: MKMapView!
    let bottomSheetVC = BottomSheetVC()
    

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
        addBottomSheetView()
        
    }
    
    func addBottomSheetView(scrollable: Bool? = true) {
        self.addChild(bottomSheetVC)
        self.view.addSubview(bottomSheetVC.view)
        bottomSheetVC.didMove(toParent: self)

        let height = view.frame.height
        let width  = view.frame.width
        bottomSheetVC.view.frame = CGRect(x: 0, y: self.view.frame.maxY, width: width, height: height)
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
extension MapVC: MapPresenterToViewProtocol{

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
        AlertControl().showAlert(title: AlertMsg.headerErrorMessage, message: AlertMsg.DescServerErrMsg, viewController: self, okButtonTitle: AlertMsg.actionOkay)
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
                print(previousLocation)
                
                if previousLocation.coordinate.latitude == 0.0 || previousLocation.coordinate.longitude == 0.0{
                    previousLocation = locationPresenter!.currentUserLocation
                    checkCovidRules(cases7per100: feature.attributes!.cases7_per_100k)
                }else{
                    let presentNotification: Bool = calculateDistancE(previousCoordinnate: previousLocation, newCoordinate: locationPresenter!.currentUserLocation)
                    if presentNotification{
                        previousLocation = locationPresenter!.currentUserLocation
                        checkCovidRules(cases7per100: feature.attributes!.cases7_per_100k)
                    }
                }
                
                
            }else{
//                print("Not in Polygonn")
            }
        }
        
        func checkCovidRules(cases7per100: Float) {
            switch cases7per100 {
            case 0..<35:
                bottomSheetVC.setMessage(msg: CovidRulesMsg.rulesMsgGreen)
                UNUserNotificationCenter.sendCovideAlertMsg(title: Notification.notificationTitle, message: CovidRulesMsg.rulesMsgGreen)
            case 36..<50:
                bottomSheetVC.setMessage(msg: CovidRulesMsg.rulesMsgYellow)
                UNUserNotificationCenter.sendCovideAlertMsg(title: Notification.notificationTitle, message: CovidRulesMsg.rulesMsgYellow)
            case 51..<100:
                bottomSheetVC.setMessage(msg: CovidRulesMsg.rulesMsgRed)
                UNUserNotificationCenter.sendCovideAlertMsg(title: Notification.notificationTitle, message: CovidRulesMsg.rulesMsgRed)
            default:
                bottomSheetVC.setMessage(msg: CovidRulesMsg.rulesMsgDarkRed)
                UNUserNotificationCenter.sendCovideAlertMsg(title: Notification.notificationTitle, message: CovidRulesMsg.rulesMsgDarkRed)
            }
        }
        
        func calculateDistancE(previousCoordinnate: CLLocation,newCoordinate: CLLocation) -> Bool {
            let distanceInMeters = previousCoordinnate.distance(from: newCoordinate)
            let distanceInmiles = distanceInMeters / 1609
            if distanceInmiles > 1.5{
                return true
            }else{
                return false
            }
        }
}

extension MapVC {
    func onFetchStart() {
        bottomSheetVC.onFetchStart()
    }
    
    func onFetchEnd() {
        bottomSheetVC.onFetchEnd()
    }
}
