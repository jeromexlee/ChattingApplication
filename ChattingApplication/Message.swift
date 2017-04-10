//
//  Message.swift
//  ChattingApplication
//
//  Created by XINHAO LI on 4/7/17.
//  Copyright © 2017 XINHAO LI. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {
    var fromId: String?
    var text: String?
    var timestamp: NSNumber?
    var toId: String?
    
    var imageUrl: String?
    
    func chatPartnerId() -> String? {
        return fromId == FIRAuth.auth()?.currentUser?.uid ? toId : fromId
    }
}
