//
//  WebServiceErros.swift
//  BavariaCovid
//
//  Created by PRAKASH on 12/18/20.
//

import Alamofire

enum WebServiceError: Error {
    case DataNotAvailable
    case CannotProcessData
    case NoInternetConnection
    case MaximumRetryExceed
}
