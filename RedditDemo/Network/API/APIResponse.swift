
//
//  APIContants.swift
//  BandPass
//
//  Created by Jassie on 12/01/16.
//  Copyright © 2016 eeGames. All rights reserved.
//

import Foundation
import SwiftyJSON
typealias ArrayList<T> = [T]
extension API{
    /*
     if let jsonData = data?.rawString()?.data(using: .utf8)
     {
     do {
     let userObj = try JSONDecoder().decodeJson(User.self, from: jsonData)
     userObj.access_token = parameters?.dictionary?["data"]!["token"].string
     return userObj as AnyObject
     }catch{
     print(error as Any)
     return User() as AnyObject
     }
     }else{
     return User() as AnyObject
     }
     let data =  parameters?.dictionary?["successData"]
     let response:ChatObject = decodeJson(data) ?? ChatObject()
     return Response.init(data: response as AnyObject,message)
     if let response:[SlotModel] = decodeJson(data), isSuccess{
         return Response.init(data: response as AnyObject,message,isSuccess)
     }else{Us
         return Response.init(data: nil,message,isSuccess)
     }
     */
    func handleResponse(parameters : JSON?) -> Response {
        // For message and succses cases for API Calls
//        let message = parameters?.dictionary?["message"]?.rawValue as? String ?? ""
//        let isSuccess = parameters?.dictionary?["status"]?.rawValue as? Bool ?? ((parameters?.dictionary?["status"]?.rawValue as? Int ?? Int(parameters?.dictionary?["status"]?.rawValue as? String ?? "0")) == 1)
        let data = parameters?.dictionary?["data"]
        switch self {
        case .getListing:
            if let response:RedditData = decodeJson(data){
                return Response.init(data: response as AnyObject,"",true)
            }else{
                return Response.init(data: nil,"",false)
            }
        }
    }
    
}

enum APIValidation : String{
    case None
    case Success = "1"
    case ServerIssue = "500"
    case Failed = "0"
    case TokenInvalid = "401"
}

enum APIResponse {
    case Success(Response?)
    case Failure(Response?)
    case Progress(Double?)
}

class Response {
    var data :AnyObject?
    var message:String = ""
    var isSuccess:Bool = false
    init(data:AnyObject?,_ message:String = "",_ isSuccess:Bool = false) {
        self.data = data
        self.message = message
        self.isSuccess = isSuccess
    }
}

func decodeJson<T: Decodable>(_ dataJS: JSON?) -> T?{
    if let data = dataJS?.rawString()?.data(using: .utf8){
        do {
            let model = try JSONDecoder().decode(T.self, from: data)
            return model
        } catch {
            print(error as Any)
            return nil
        }
    }else{
        print("Error Parsing")
        return nil
    }
}

func decodeJson<T: Decodable>(_ dataJS: NSDictionary?) -> T?{
    if let items = dataJS{
        return decodeJson(JSON.init(items))
    }else{
        return nil
    }
}

func decodeJson<T: Decodable>(_ dataJS: String?) -> T?{
    if let data = dataJS?.data(using: .utf8){
        do {
            let model = try JSONDecoder().decode(T.self, from: data)
            return model
        } catch {
            print(error as Any)
            return nil
        }
    }else{
        print("Error Parsing")
        return nil
    }
}



