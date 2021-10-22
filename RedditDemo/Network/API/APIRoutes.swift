
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

typealias OptionalDictionary = [String : Any]?
typealias OptionalStructDictionary = Codable?
typealias OptionalDictionaryWithDicParam = [String : [String:Any]]?
typealias OptionalSwiftJSONParameters = [String : JSON]?

infix operator =>
infix operator =|
infix operator =<
infix operator =/

func =>(key : String, json : OptionalSwiftJSONParameters) -> String?{
    return json?[key]?.stringValue
}

func =<(key : String, json : OptionalSwiftJSONParameters) -> Double?{
    return json?[key]?.double
}

func =|(key : String, json : OptionalSwiftJSONParameters) -> [JSON]?{
    return json?[key]?.arrayValue
}

func =/(key : String, json : OptionalSwiftJSONParameters) -> Int?{
    return json?[key]?.intValue
}

prefix operator ¿
prefix func ¿(value : String?) -> String {
    return value.unwrap()
}


protocol Router {
    var route : String { get }
    var baseURL : String { get }
    var parameters : OptionalDictionary { get }
    var method : Alamofire.HTTPMethod { get }
}



enum API {
    
    static func mapKeysAndValues(_ tempKeys : [String],_ tempValues : [Any]) -> [String : Any]{
        
        var params = [String : Any]()
        for (key,value) in zip(tempKeys,tempValues) {
            params[key] = value
        }
        return params
    }
    
    static func mapKeysAndValuesDic(_ tempKeys : [String],_ tempValues : [Any]) -> [String:[String:Any]]{
        var params = [String : [String:Any]]()
        for (key,value) in zip(tempKeys,tempValues) {
            if let itemValue = value as? [String:Any] {
                params[key] = itemValue
            }
        }
        return params
    }
    
    // For Enter Case of api calls
    case getListing(after:String? = nil)
}



extension API : Router{
    // For Return API Paths
    var route : String {
        switch self {
        case .getListing(after: let after):
            return after == nil ? .getListings : .getListings+"?after=\(after!)"
       
        }
    }
    
    var baseURL : String {  return APIConstants.BasePath }
    
    var parameters : OptionalDictionary {
        let pm = formatParameters()
        return pm
    }
    
    var classTypeParam:OptionalStructDictionary {
        let pm = formatEncodable()
        return pm
    }
    
    func url() -> String {
        return URL.init(baseURL + route)?.absoluteString ?? ""//().RemoveSpace()
    }
    // For Return Method Type
    var method: Alamofire.HTTPMethod {
        switch self {
        
        default: return .get
        }
    }
    // For Return Each APi Case Headers Type
    var header:Alamofire.HTTPHeaders{
        switch self{
            
        case .getListing:
            var header = Alamofire.HTTPHeaders.init()
            header.add(name: "Content-Type", value: "application/json")
            header.add(name: "Accept", value: "application/json")
            return header
        }
    }
    
    var encoder:Alamofire.ParameterEncoder {
        switch self {
        //        case .sendComment , .createAlert:
        //            return JSONParameterEncoder.default
        ////            return URLEncodedFormParameterEncoder.default
        default:
            return JSONParameterEncoder.default
        }
    }
    
    var encoding:Alamofire.ParameterEncoding {
        switch self {
        //        case .sendComment, .createAlert:
        //            return JSONEncoding.default
        default:
            return JSONEncoding.default//URLEncoding.default
        }
    }
}

extension API {
    func formatParameters() -> OptionalDictionary {
        switch self {
        
        case .getListing:
            return [:]
        }
    }
    
    func formatEncodable() -> OptionalStructDictionary {
        switch self {
        
        default:
            return nil
        }
    }
    
    
    
}





extension URL {
    func mimeType() -> String {
        let pathExtension = self.pathExtension
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
        return "application/octet-stream"
    }
}

extension URL {
    func getFileCompleteName() -> String {
        return self.lastPathComponent
    }
    func getFileName() -> String {
        return String(self.lastPathComponent.split(separator: ".").first ?? "")
    }
    
    func getFileExtension() -> String {
        return String(self.lastPathComponent.split(separator: ".").last ?? "")
    }
}

extension URL {
    var attributes: [FileAttributeKey : Any]? {
        do {
            return try FileManager.default.attributesOfItem(atPath: path)
        } catch let error as NSError {
            print("FileAttribute error: \(error)")
        }
        return nil
    }
    
    var fileSize: UInt64 {
        return attributes?[.size] as? UInt64 ?? UInt64(0)
    }
    
    var fileSizeString: String {
        return ByteCountFormatter.string(fromByteCount: Int64(fileSize), countStyle: .file)
    }
    
    var creationDate: Date? {
        return attributes?[.creationDate] as? Date
    }
}

extension URL {
    init?(_ string: String) {
        guard string.isEmpty == false else {
            return nil
        }
        if let url = URL(string: string) {
            self = url
        } else if let urlEscapedString = string.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed),
                  let escapedURL = URL(string: urlEscapedString) {
            self = escapedURL
        } else {
            return nil
        }
    }
}


extension URL {
    /// Adds a unique path to url
    func appendingUniquePathComponent(pathExtension: String? = nil) -> URL {
        var pathComponent = UUID().uuidString
        if let pathExtension = pathExtension {
            pathComponent += ".\(pathExtension)"
        }
        return appendingPathComponent(pathComponent)
    }
}


protocol StringType { var get: String { get } }
extension String: StringType { var get: String { return self } }
extension Optional where Wrapped: StringType {
    func unwrap() -> String {
        return self?.get ?? ""
    }
}

extension String {
    
    var parseJSONString: AnyObject? {
        
        let data = self.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        if let jsonData = data {
            // Will return an object or nil if JSON decoding fails
            do{
                if let json = try (JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary){
                    return json
                }else{
                    let json = try (JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSArray)
                    return json
                }
                
            }catch{
                print("Error")
            }
            
        } else {
            // Lossless conversion of the string was not possible
            return nil
        }
        
        return nil
    }
    
    var parseJSONStringArray: AnyObject? {
        
        let data = self.data(using: String.Encoding.utf8, allowLossyConversion: false)
        let json:NSArray
        
        if let jsonData = data {
            // Will return an object or nil if JSON decoding fails
            do{
                json  = try  JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers)  as! NSArray
                
                return json
            }catch{
                print("Error")
            }
            
        } else {
            // Lossless conversion of the string was not possible
            return nil
        }
        
        return nil
    }
}
