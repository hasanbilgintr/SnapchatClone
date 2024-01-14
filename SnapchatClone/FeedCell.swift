

/*
 bu //coco touch classtır
 
 storyboardda olan ekranında satır için table View Cell kısmına seçili olup Class FeedCell seçildi ve identifier içinde Cell yazdık
 */

import UIKit

class FeedCell: UITableViewCell {
//eklerken hata verirse proje kapatılıp aç
    @IBOutlet weak var feedUserNameLabel: UILabel!
    @IBOutlet weak var feedImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
