//
//  UaerSingleton.swift
//  SnapchatClone
//
//  Created by hasan bilgin on 17.10.2023.
//

import Foundation

class UserSingleton{
    
    static let sharedUserInfo = UserSingleton()
    
    var email = ""
    var username = ""
    
    private init (){
        
    }
}
