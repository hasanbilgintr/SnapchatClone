/*
 dosyaları klasörleyebiliriz new group diyerek 
 */

import UIKit
import Firebase

class SignInVC: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func signInClicked(_ sender: Any) {
        if  passwordText.text != "" && emailText.text != "" {
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { (result, error) in
                if error != nil {
                    self.makeAlert(title: "Error", messsage: error?.localizedDescription ?? "Error")
                }else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        }else{
            self.makeAlert(title: "Error", messsage: "Password / Email ?")
        }
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        if usernameText.text != "" && passwordText.text != "" && emailText.text != "" {
            Auth.auth().createUser(withEmail: emailText.text!,password: passwordText.text!) { auth, error in
                if error != nil {
                    self.makeAlert(title: "Error", messsage: error?.localizedDescription ?? "Error")
                }else{
                    
                    let fireStore = Firestore.firestore()
                    let userDictionary = ["email":self.emailText.text!,"username":self.usernameText.text!] as [String: Any]
                    
                    fireStore.collection("UserInfo").addDocument(data: userDictionary) { error in
                        if error != nil {
                            //hata verdiliğinde yazılabilir
                        }
                    }
                    
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        }else{
            self.makeAlert(title: "Error", messsage: "Username / Password / Email ?")
        }
       
    }
    
    func makeAlert(title: String , messsage : String){
        let alert = UIAlertController(title: title, message: messsage, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}

