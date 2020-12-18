//
//  FeatureModel.swift
//  BavariaCovid
//
//  Created by PRAKASH on 12/18/20.
//

import UIKit
import MapKit

class FeatureModel: NSObject, Codable {
    
    var attributes: CovidCaseModel?
    var geometry : RingsModel?

    enum CodingKeys: String, CodingKey {
        case attributes = "attributes"
        case geometry = "geometry"
    }

    override init() {
        super.init()
    }

    required init(from decoder: Decoder) throws {
        let json = try decoder.container(keyedBy: CodingKeys.self)
        do { self.attributes = try json.decode(CovidCaseModel.self, forKey: .attributes) } catch { print("Feature model ***attributes*** JSON parse error. \(error.localizedDescription)") }
        do { self.geometry = try json.decode(RingsModel.self, forKey: .geometry) } catch { print("Feature model ***geometry*** JSON parse error. \(error.localizedDescription)") }
    }
    
    
    
    func toCoordinates() -> [CLLocationCoordinate2D] {
        return (geometry?
                    .rings
                    .map { data in
                        return data.map {
                            FeatureModel.coordinate(from: $0)
                        }
                    }.reduce([], +))!
    }

    static func coordinate(from points: [Double]) -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: points.last!, longitude: points.first!)
    }
}
