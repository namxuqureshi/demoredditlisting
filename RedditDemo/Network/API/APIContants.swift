
//
//  APIContants.swift
//  BandPass
//
//  Created by Jassie on 12/01/16.
//  Copyright © 2016 eeGames. All rights reserved.
//

import Foundation
import Alamofire

func print(_ items: Any...) {
    #if DEBUG
    Swift.print(items[0])
    #endif
}

internal struct Build{
    static let isProduction = 0
}

internal struct APIConstants {
    static let BaseIp = "www.reddit.com"
    static let BasePath = "https://\(BaseIp)"
    
    
    
}



extension String {
    static let getListings = "/.json"
}





internal struct APIParameterConstants {
 
    
}

enum FileParamName :String{
    case PictureFile = "Attachment.File"
    case Media = "media"
    case IdProofFile = "IdProof.File"
    case ESignatureFile = "ESignature.File"
    case ReferenceAttachmentFile = "ReferenceAttachment.File"
}

enum FileSendType:String {
    case vendor_document = "vendor_document"
}
