//
//  MapRouter.swift
//  BavariaCovid
//
//  Created by PRAKASH on 12/18/20.
//

import UIKit

class MapRouter : MapPresenterToRouterProtocol{
    
    // MARK: - Methods
    
    class func createModule() -> UIViewController {
        
        let view = MapVC()
        let presenter: MapViewToPresenterProtocol & MapInteractorToPresenterProtocol = MapPresenter()
        let interactor: MapPresentorToInteractorProtocol = MapInteractor()
        let router: MapPresenterToRouterProtocol = MapRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return view
    }
    
    static var mainstoryboard: UIStoryboard {
        return UIStoryboard(name:"Main",bundle: Bundle.main)
    }
}
