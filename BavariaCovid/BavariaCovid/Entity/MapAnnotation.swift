//
//  MapAnnotation.swift
//  BavariaCovid
//
//  Created by PRAKASH on 12/18/20.
//

import MapKit

class Artwork: NSObject, MKAnnotation {
  let title: String?
  let coordinate: CLLocationCoordinate2D

  init(title: String, coordinate: CLLocationCoordinate2D) {
    self.title = title
    self.coordinate = coordinate
    super.init()
  }
}
