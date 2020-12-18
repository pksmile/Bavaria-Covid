//
//  MapInteractor.swift
//  BavariaCovid
//
//  Created by PRAKASH on 12/18/20.
//

import Alamofire
import UIKit

class MapInteractor: MapPresentorToInteractorProtocol {
    
    // MARK: - Properties
    weak var presenter: MapInteractorToPresenterProtocol?
    var features: [FeatureModel]?
    
    // MARK: - Methods
    func fetchCovidCases() {
        let route = APIRouter.getCovidCases(where: "1=1", outFields: "*", outSR: "4326")
        AF.request(route)
            .responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success(let json):
                    let jsonUser =  (json as AnyObject)
                    let decoder = JSONDecoder()
                    do {
                        let covidCaseResponse = try decoder.decode(CovidCaseResponse.self, from: JSONSerialization.data(withJSONObject: jsonUser, options: .prettyPrinted))
                        self.features    =   covidCaseResponse.features
                        self.presenter?.covidCaseFetched()
                        
                    } catch {
                        print("Error trying to convert data to JSON. \(error.localizedDescription)")
                        self.presenter?.covidCaseFetchedFailed()
                    }
                    
                case .failure(let error):
                    print("Error trying to convert data to JSON. \(error.localizedDescription)")
                    //                    let dictSend = ["status" : "Fail", "message" : error.localizedDescription] as [String : AnyObject]
                    self.presenter?.covidCaseFetchedFailed()
                }
                
            })
    }
}
