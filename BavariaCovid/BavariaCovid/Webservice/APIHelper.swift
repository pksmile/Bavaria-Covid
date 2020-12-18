//
//  APIHelper.swift
//  BavariaCovid
//
//  Created by PRAKASH on 12/18/20.
//

import Foundation

struct APIHelper {
    struct Server {
        static let baseURL = "https://services7.arcgis.com/mOBPykOjAyBO2ZKk/arcgis/rest/services/RKI_Landkreisdaten/FeatureServer/"
    }
    
    struct APIURLQueryKey {
        static let whereKey    =   "where"
        static let fieldsKey    =   "outFields"
        static let outSRKey    =   "outSR"
        static let formatKey    =   "f"
    }
    
    struct APIURLQueryValue {
        static let formatJson    =   "json"
    }
    
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
    case accessToken = "access_token"
}


enum ContentType: String {
    case json = "application/json"
    case urlEncoded =   "application/x-www-form-urlencoded"
}
