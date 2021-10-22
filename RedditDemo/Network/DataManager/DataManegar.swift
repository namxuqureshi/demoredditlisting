//
//  DataManegar.swift
//  Trecco
//
//  Created by Jassie on 11/11/19.
//  Copyright © 2019 Jhony. All rights reserved.
//

import UIKit
import MapKit
import Alamofire


class DataManager: NSObject {
    
    
    
    var screenWidth:CGFloat{
        set(value){
            setScreenWidth(value:value)
        }
        get{
            return getScreenWidth()
        }
    }
    
    var screenHeight:CGFloat{
        set(value){
            setScreenHeight(value:value)
        }
        get{
            return getScreenHeight()
        }
    }
    
    func getScreenWidth() -> CGFloat {
        return CGFloat.init(UserDefaults.standard.double(forKey: "ScreenWidth"))
    }
    
    func setScreenWidth(value:CGFloat) {
        UserDefaults.standard.set(Double.init(value), forKey: "ScreenWidth")
    }
    
    func getScreenHeight() -> CGFloat {
        return CGFloat.init(UserDefaults.standard.double(forKey: "ScreenHeight"))
    }
    
    func setScreenHeight(value:CGFloat) {
        UserDefaults.standard.set(Double.init(value), forKey: "ScreenHeight")
    }
    
    var deviceToken:String = UIDevice.current.identifierForVendor?.uuidString ?? UUID.init().uuidString
    
    static let sharedInstance = DataManager()
    
    func clearUser(){
        UserDefaults.standard.removeObject(forKey: "user")
    }
    
    func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
    
    
    
    
}

