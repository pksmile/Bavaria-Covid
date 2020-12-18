//
//  CovidCaseResponse.swift
//  BavariaCovid
//
//  Created by PRAKASH on 12/18/20.
//

import Foundation

class CovidCaseResponse: NSObject, Codable {
    var features: [FeatureModel] = []
    
    enum CodingKeys: String, CodingKey {
        case features = "features"
    }

    override init() {
        super.init()
    }

    required init(from decoder: Decoder) throws {
        let json = try decoder.container(keyedBy: CodingKeys.self)
        do { self.features = try json.decode([FeatureModel].self, forKey: .features) } catch { print("CovidCaseResponse model ***feature*** JSON parse error. \(error.localizedDescription)") }
    }
}
