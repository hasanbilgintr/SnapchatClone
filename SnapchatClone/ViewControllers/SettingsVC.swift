//
//  SettingsVC.swift
//  SnapchatClone
//
//  Created by hasan bilgin on 16.10.2023.
//

import UIKit
import Firebase

class SettingsVC: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    

    @IBAction func logoutClicked(_ sender: Any) {
        do{
            try  Auth.auth().signOut()
            self.performSegue(withIdentifier: "toSignInVC", sender: nil)
        }catch{
            
        }
      
        
    }
    //storyboarddan koyarken hata gelirse ya proje tamamen kapat aç yada iki build te et
}
