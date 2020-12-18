//
//  Rings.swift
//  BavariaCovid
//
//  Created by PRAKASH on 12/18/20.
//

import Foundation

class RingsModel: NSObject, Codable  {
    var rings: [[[Double]]] = []
    
    enum CodingKeys: String, CodingKey {
        case rings = "rings"
    }

    override init() {
        super.init()
    }

    required init(from decoder: Decoder) throws {
        let json = try decoder.container(keyedBy: CodingKeys.self)
        do { self.rings = try json.decode([[[Double]]].self, forKey: .rings) } catch { print("Rings model ***rings*** JSON parse error. \(error.localizedDescription)") }
    }
}
