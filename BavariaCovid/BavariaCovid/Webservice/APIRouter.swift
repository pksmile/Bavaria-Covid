//
//  APIRouter.swift
//  BavariaCovid
//
//  Created by PRAKASH on 12/18/20.
//
import UIKit
import Alamofire

enum APIRouter: URLRequestConvertible {
    case getCovidCases(where: String, outFields: String, outSR: String)
    // MARK: - HTTPMethod
    private var method: HTTPMethod {
        switch self {
        case .getCovidCases:
            return .get
        }
        
    }
    
    // MARK: - Path
    private var path: String {
        switch self {
        case .getCovidCases:
            return "0/query"
        }
    }
    
    // MARK: - Parameters
    var parameters: Parameters? {
        switch self {
       
        case .getCovidCases:
            return nil
        }
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        
        let url: URL = try APIHelper.Server.baseURL.asURL()
        var urlRequest: URLRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        switch self {
        case .getCovidCases(let whereValue, let outFields, let outSR):
            var urlComponents = URLComponents(string: url.appendingPathComponent(path).absoluteString)!
            
            urlComponents.queryItems = [
                URLQueryItem(name: APIHelper.APIURLQueryKey.whereKey, value: "\(whereValue)"),
                URLQueryItem(name: APIHelper.APIURLQueryKey.fieldsKey, value: "\(outFields)"),
                URLQueryItem(name: APIHelper.APIURLQueryKey.outSRKey, value: "\(outSR)"),
                URLQueryItem(name: APIHelper.APIURLQueryKey.formatKey, value: APIHelper.APIURLQueryValue.formatJson)
            ]
            
            urlRequest = URLRequest(url: urlComponents.url!)
            urlRequest.httpMethod = method.rawValue
        }
        
        return urlRequest
    }
   
}
