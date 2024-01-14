

import UIKit
import Firebase
import SDWebImage

class FeedVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let fireStoreDatabase = Firestore.firestore()
    var snapArray = [SnapModel]()
    var chosenSnap : SnapModel?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getUserInfo()
        getSnapsFromFirebase()
    }
    
    func getSnapsFromFirebase(){
        //(snapshot, error) parantez içinde olmasına gerek yok hata vermiyor
        fireStoreDatabase.collection("Snaps").order(by: "date", descending: true).addSnapshotListener { snapshot, error in
            if error != nil {
                
            }else{
                if snapshot?.isEmpty == false && snapshot != nil {
                    //bunu kullanalım removeAll() değil
                    self.snapArray.removeAll(keepingCapacity: false)
                    for document in snapshot!.documents {
                        
                        let documentId = document.documentID
                        
                        if let username = document.get("snapOwner") as? String {
                            if let imageUrlArray = document.get("imageUrlArray") as? [String]{
                                if let date = document.get("date") as? Timestamp{
                                    
                                    // date.dateValue() bu zamandan Date() şimdiki zaman farkını ver somnunda saate çevir demek
                                    if let diffrerence = Calendar.current.dateComponents([.hour], from: date.dateValue(), to: Date()).hour {
                                        if diffrerence >= 24 {
                                            self.fireStoreDatabase.collection("Snaps").document(documentId).delete { error in
                                                if error == nil {
                                                    //silindi denilebilir
                                                }
                                            }
                                        }else{
                                            let snap = SnapModel(userName: username, imageUrlArray: imageUrlArray, date: date.dateValue(),timeDifference: 24 - diffrerence)
                                            self.snapArray.append(snap)
                                        }
                                    }
                                   
                                }
                            }
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    
    func getUserInfo(){
        //getDocuments diyerek 1 kez çekilmesi istendi
        fireStoreDatabase.collection("UserInfo").whereField("email", isEqualTo: Auth.auth().currentUser!.email!).getDocuments { snapshot, error in
            if error != nil {
                self.makeAlert(title: "Error", messsage: error?.localizedDescription ?? "Error")
            }else{
                if snapshot?.isEmpty == false && snapshot != nil {
                    for document in snapshot!.documents {
                        if let username = document.get("username") as? String{
                            UserSingleton.sharedUserInfo.email = Auth.auth().currentUser!.email!
                            UserSingleton.sharedUserInfo.username = username
                        }
                    }
                }
            }
            
        }
    }
    //tableview satır sayısı
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return snapArray.count
    }
    
    //data gösterilmesi
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //identitfier giirldi
        //FeedCell e aktarıldı diyebiliriz o bir coco touch classtır
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        cell.feedUserNameLabel.text = snapArray[indexPath.row].userName
        cell.feedImageView.sd_setImage(with: URL(string: snapArray[indexPath.row].imageUrlArray[0]),  placeholderImage: UIImage(named: "selectImage") )
//        cell.feedImageView.sd_setImage(with: URL(string: snapArray[indexPath.row].imageUrlArray[0])) // ikisidde çalışıor
        
        return cell
    }
    func makeAlert(title: String , messsage : String){
        let alert = UIAlertController(title: title, message: messsage, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    //resim height ve widht ayarlarken tümünü reset to sugested.. yapıp sonra height ve widht sınırlarsak lazım ozaman sorun kalmıyo
    
    //ekren geçişi yapmadna önceki metot (segue hazırlamada diyebiliriz)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSnapVC" {
            let destinationVC = segue.destination as! SnapVC
            destinationVC.selectedSnap = chosenSnap
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenSnap = self.snapArray[indexPath.row]
        performSegue(withIdentifier: "toSnapVC", sender: nil)
    }
}
