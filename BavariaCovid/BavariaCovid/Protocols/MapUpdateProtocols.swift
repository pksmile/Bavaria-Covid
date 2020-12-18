//
//  MapInteractorProtocol.swift
//  BavariaCovid
//
//  Created by PRAKASH on 12/18/20.
//

import UIKit

protocol MapPresenterToViewProtocol: class {
    func drawColorsOnMap()
    func showError()
}

protocol MapInteractorToPresenterProtocol: class {
    func covidCaseFetched()
    func covidCaseFetchedFailed()
}


protocol MapPresentorToInteractorProtocol: class {
    var presenter: MapInteractorToPresenterProtocol? { get set }
    var features: [FeatureModel]? { get }
    
    func fetchCovidCases()
}

protocol MapViewToPresenterProtocol :  class{
    var view: MapPresenterToViewProtocol? { get set }
    var interactor: MapPresentorToInteractorProtocol? { get set }
    var router: MapPresenterToRouterProtocol? { get set }
    
    
    func updateView()
    func allFeatures() -> [FeatureModel]?
}

protocol MapPresenterToRouterProtocol: class {
    static func createModule() -> UIViewController
}
