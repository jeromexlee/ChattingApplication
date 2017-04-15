//
//  Message.swift
//  ChattingApplication
//
//  Created by XINHAO LI on 4/7/17.
//  Copyright © 2017 XINHAO LI. All rights reserved.
//

import UIKit
import Firebase
import Parse

class Message: NSObject {
    var fromId: String?
    var text: String?
    var timestamp: NSNumber?
    var toId: String?
    
    // sending image or video
    var imageUrl: String?
    var imageWidth: NSNumber?
    var imageHeight: NSNumber?
    
    // sending video
    var videoUrl: String?
    
    // sending voice
    var voiceUrl: String?
    
    func chatPartnerId() -> String? {
        return (fromId == FIRAuth.auth()?.currentUser?.uid || fromId == PFUser.current()?.objectId) ? toId : fromId
    }
    
    init(dictionary: [String: AnyObject]) {
        super.init()
        fromId = dictionary["fromId"] as? String
        text = dictionary["text"] as? String
        timestamp = dictionary["timestamp"] as? NSNumber
        toId = dictionary["toId"] as? String
        
        imageUrl = dictionary["imageUrl"] as? String
        imageWidth = dictionary["imageWidth"] as? NSNumber
        imageHeight = dictionary["imageHeight"] as? NSNumber
        
        videoUrl = dictionary["videoUrl"] as? String
        voiceUrl = dictionary["voiceUrl"] as? String
    }
}
