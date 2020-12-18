//
//  MapPresenter.swift
//  BavariaCovid
//
//  Created by PRAKASH on 12/18/20.
//

import Foundation

class MapPresenter: MapViewToPresenterProtocol {
    
    // MARK: - Properties
    weak var view: MapPresenterToViewProtocol?
    var interactor: MapPresentorToInteractorProtocol?
    var router: MapPresenterToRouterProtocol?
    
    // MARK: - Methods
    func updateView() {
        interactor?.fetchCovidCases()
    }
    
    func allFeatures() -> [FeatureModel]?{
        return interactor?.features
    }
}

// MARK: - LiveNewsListInteractorToPresenterProtocol
extension MapPresenter: MapInteractorToPresenterProtocol {
    
    func covidCaseFetched() {
        view?.drawColorsOnMap()
    }
    
    func covidCaseFetchedFailed() {
        view?.showError()
    }
}
