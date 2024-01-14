

import UIKit

//Storage  için eklendi
import FirebaseStorage

//FireStore için
import FirebaseFirestore

import Firebase





class UploadVC: UIViewController ,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    @IBOutlet weak var uploadImageview: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uploadImageview.isUserInteractionEnabled = true
        let gestureREcognizer = UITapGestureRecognizer(target: self, action: #selector(choosePicture))
        uploadImageview.addGestureRecognizer(gestureREcognizer)
        
    }
    
    //resim seçilince
    @objc func choosePicture (){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        uploadImageview.image = info [.originalImage] as? UIImage
        self.dismiss(animated: true)
    }
    
    @IBAction func uploadClicked(_ sender: Any) {
        
        //storage
        
        let storage = Storage.storage()
        let storageReferance = storage.reference()
        
        let mediaFolder = storageReferance.child("media")
        if let data = uploadImageview.image?.jpegData(compressionQuality: 0.5) {
            let uuid = UUID().uuidString
            
            
            let imageReferance = mediaFolder.child("\(uuid).jpeg")
            imageReferance.putData(data) { metadata, error in
                if error != nil {
                    self.makeAlert(title: "Error", messsage: error?.localizedDescription ?? "Error")
                }else {
                    imageReferance.downloadURL { url, error in
                        if error == nil {
                            //url stringe çevirmiş
                            let imageUrl = url?.absoluteString
                            
                            
                            //FireStore
                            
                            let fireStore = Firestore.firestore()
                            
                            fireStore.collection("Snaps").whereField("snapOwner", isEqualTo: UserSingleton.sharedUserInfo.username).getDocuments { (snapshot, error) in
                                if error != nil {
                                    self.makeAlert(title: "Error", messsage: error?.localizedDescription ?? "Error")
                                }else{
                                    if snapshot?.isEmpty == false && snapshot != nil {
                                        for document in snapshot!.documents {
                                            let documentId = document.documentID
                                            
                                            if var imageUrlArray = document.get("imageUrlArray") as? [String]{
                                                imageUrlArray.append(imageUrl!)
                                                
                                                let additionaDixtionary = ["imageUrlArray": imageUrlArray] as [String : Any]
                                                
                                                fireStore.collection("Snaps").document(documentId).setData(additionaDixtionary, merge: true) { error in
                                                    if error == nil {
                                                        
                                                        self.tabBarController?.selectedIndex = 0
                                                        self.uploadImageview.image = UIImage(named: "selectImage")
                                                    }
                                                }
                                            }
                                        }
                                    }else{
                                        let snapDictionary = ["imageUrlArray": [imageUrl!],"snapOwner":UserSingleton.sharedUserInfo.username,"date": FieldValue.serverTimestamp()] as [String : Any]
                                        fireStore.collection("Snaps").addDocument(data: snapDictionary) { error in
                                            if error != nil {
                                                self.makeAlert(title: "Error", messsage: error?.localizedDescription ?? "Error")
                                            }else{
                                                self.tabBarController?.selectedIndex = 0
                                                self.uploadImageview.image = UIImage(named: "selectImage")
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func makeAlert(title: String , messsage : String){
        let alert = UIAlertController(title: title, message: messsage, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
}
