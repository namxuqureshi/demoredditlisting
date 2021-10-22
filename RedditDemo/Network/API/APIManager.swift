
//
// APIContants.swift
// BandPass

import Foundation
import SwiftyJSON
import Alamofire

typealias APICompletion = (APIResponse) -> ()

class APIManager: NSObject {
    
    static let sharedInstance = APIManager()
    private lazy var httpClient : HTTPClient = HTTPClient()
    
    func operationWithFile( withApi api : API ,fileUrl:[URL?]?,paramName: [FileParamName],type: [FileSendType], completion : @escaping APICompletion ){
        httpClient.withFile(withApi: api, fileUrl: fileUrl, paramName: paramName,type:type,progressCompletation: { (progress) in
            completion(APIResponse.Progress(progress))
        }, success: { (data,headers) in
            self.handleResponse(api:api,data:data,headers: headers,completion: completion)
        }) { (error,headers) in
            self.handleErrors(api:api,error:error,headers: headers,completion: completion)
        }
    }
    
    func removeCall(){
        httpClient.removeCall()
    }
    
    func opertationWithRequest ( withApi api : API , completion : @escaping APICompletion ) {
        
        httpClient.postRequest(withApi: api, success: { (data,headers) in
            self.handleResponse(api:api,data:data,headers: headers,completion: completion)
        }) { (error,headers) in
            self.handleErrors(api:api,error:error,headers: headers,completion: completion)
        }
    }
    
    private func handleErrors(api : API ,error:NSError,headers:Any, completion : @escaping APICompletion ){
        print("Url:\(api.url())\nParams: \(String(describing:api.parameters))\nResponse: \(error)\nHeaders: \(headers)")//
        completion(APIResponse.Failure(.init(data: nil, error.localizedDescription, false)))
    }
    
    private func handleResponse(api:API,data:AnyObject?,headers:Any,completion : @escaping APICompletion){
        guard let response = data else {
            completion(APIResponse.Failure(.init(data: nil, "Server Error", false)))
            return
        }
        let json = JSON(response)
//        For API cases which came with structed of message,status kind cases
//        let message = json.dictionary?["message"]?.rawValue as? String ?? ""
//        let isSuccess = json.dictionary?["status"]?.rawValue as? Bool ?? ((json.dictionary?["status"]?.rawValue as? Int ?? Int(json.dictionary?["status"]?.rawValue as? String ?? "0")) == 1)
//        if !isSuccess{
//            if message == "User Not Verified. Verification code sent to linked Email."{
//                if let data = json.dictionary?["data"]?.dictionary?["code"]?.int{
//                    completion(APIResponse.Failure(.init(data: "\(data)" as AnyObject, message, false)))
//                }else if let data = json.dictionary?["data"]?.dictionary?["code"]?.string{
//                    completion(APIResponse.Failure(.init(data: data as AnyObject, message, false)))
//                }else{
//                    completion(APIResponse.Failure(.init(data: nil, message, false)))
//                }
//            }else if message == "not_registered."{
//                completion(APIResponse.Failure(.init(data: nil, message, false)))
//            }else{
//                completion(APIResponse.Failure(.init(data: nil, message, false)))
//            }
//            return
//        }
        completion(.Success(api.handleResponse(parameters: json)))
    }
    
    
}

class ErrorModel :Codable {
//    "details" : null,
//       "validationErrors" : null,
    var code:Int? = 0
    var message:String? = ""
}

