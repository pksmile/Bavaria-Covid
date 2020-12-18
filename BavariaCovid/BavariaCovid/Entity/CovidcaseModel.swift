//
//  CovidcaseModel.swift
//  BavariaCovid
//
//  Created by PRAKASH on 12/18/20.
//

import Foundation

class CovidCaseModel: NSObject, Codable {
    var country: String = ""
    var cases7_per_100k: Float = 0.0
    

    enum CodingKeys: String, CodingKey {
        case country = "country"
        case cases7_per_100k = "cases7_per_100k"
    }

    override init() {
        super.init()
    }

    required init(from decoder: Decoder) throws {
        let json = try decoder.container(keyedBy: CodingKeys.self)
        do { self.country = try json.decode(String.self, forKey: .country) } catch { print("Covidcase model ***country*** JSON parse error. \(error.localizedDescription)") }
        do { self.cases7_per_100k = try json.decode(Float.self, forKey: .cases7_per_100k) } catch { print("Covidcase model ***cases7_per_100k*** JSON parse error. \(error.localizedDescription)") }
    }
}
