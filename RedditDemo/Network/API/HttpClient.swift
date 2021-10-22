//
//  APIContants.swift
//  BandPass
//
//  Created by Jassie on 12/01/16.
//  Copyright © 2016 eeGames. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import MobileCoreServices

typealias HttpClientSuccess = (AnyObject?,_ header: Any) -> ()
typealias HttpClientFailure = (NSError,_ header: Any) -> ()


class AlamoFireCall {
    static let shared = AlamoFireCall()
    let manager:ServerTrustManager!
    let session:Session!
    init() {
        manager = ServerTrustManager(evaluators: [APIConstants.BaseIp: DisabledTrustEvaluator()])
        session = Session(serverTrustManager: manager)//,eventMonitors: [ AlamofireLogger() ]
    }
}

final class AlamofireLogger: EventMonitor {
    func requestDidResume(_ request: Request) {
//        let body = request.request.flatMap { $0.httpBody.map { String(decoding: $0, as: UTF8.self) } } ?? "None"
        let body = request.request.flatMap { $0.httpBody.map { String(decoding: $0, as: UTF8.self) } } ?? "None"
        let message = """
        ⚡️ Request Started: \(request)
        ⚡️ Method : \(request.request?.method as Any)
        
        ⚡️ Method A : \(request.request?.httpMethod as Any)
        ⚡️ Body A : \(request.request?.httpBody as Any)
        ⚡️ Body A : \(request.request?.httpBodyStream as Any)
        ⚡️ Body A : \(request.request?.allHTTPHeaderFields as Any)
        ⚡️ Body Data: \(body)
        """
        NSLog(message)
    }

    func request(_ request: DataRequest, didParseResponse response: AFDataResponse<String>) {
        NSLog("⚡️ Response Received: \(response.debugDescription)")
    }
}


class HTTPClient {
    
    func withFile(withApi api:API,fileUrl:[URL?]?,paramName:[FileParamName],type:[FileSendType],progressCompletation : @escaping (Double?) -> (),success : @escaping HttpClientSuccess , failure : @escaping HttpClientFailure ){
        let params = api.parameters ?? [String:Any]()
        let method = api.method
        let headers = api.header
        
        AlamoFireCall.shared.session.upload(
            multipartFormData: { multiPart in
                for (key, value) in params {
                    if let value = value as? String{
                        multiPart.append(value.data(using: .utf8)!, withName: key)
                    }else if let value = value as? Int{
                        let intValie = try! JSONEncoder().encode(value)
                        multiPart.append(intValie, withName: key)
                    }else if let value = value as? Bool{
                        let boolData = try! JSONEncoder().encode(value)
                        multiPart.append(boolData, withName: key)
                    }
                }
                for item in type {
                    multiPart.append(item.rawValue.data(using: .utf8)!, withName: "type")
                }
                if let linkFiles = fileUrl {
                    for (index,item) in linkFiles.enumerated() {
                        if let linkFile = item {
                            multiPart.append(linkFile, withName: paramName[index].rawValue , fileName: linkFile.lastPathComponent, mimeType: linkFile.mimeType())
                        }
                    }
                    
                }
                
        },
            to: api.url(), method: method , headers: headers)
            .uploadProgress(queue: .main, closure: { progress in
                print("Upload Progress: \(progress.fractionCompleted)")
                progressCompletation(progress.fractionCompleted)
            })
            .responseString { response in
                self.checkResponse(headers, success: success, failure: failure, response: response)
            }
    }
    
    func removeCall(){
        AlamoFireCall.shared.session.cancelAllRequests()
    }
    
    
    func checkResponse(_ headers: HTTPHeaders,success : @escaping HttpClientSuccess , failure : @escaping HttpClientFailure,response:AFDataResponse<String>){
        switch(response.result) {
        case .success(let value):
//            print("Response Items : \(value.parseJSONString as Any)")
            success(value.parseJSONString as AnyObject?,headers)
        case .failure(let error):
            failure(error as NSError,headers)
        }
    }
    
    func postRequest(withApi api : API  , success : @escaping HttpClientSuccess , failure : @escaping HttpClientFailure )  {
        let params = api.parameters
        let method = api.method
        let headers = api.header
        
        AlamoFireCall.shared.session.request(api.url(), method: method,parameters: method == .get ? nil : params, encoding: api.encoding, headers: headers).responseString { response in
            self.checkResponse(headers, success: success, failure: failure, response: response)
        }
    }
    
}



