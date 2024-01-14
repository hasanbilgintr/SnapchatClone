
/*
 https://github.com/zvonicek/ImageSlideshow  slider için
 ImageSlidesShow
 ImageSlidesShow/Kingfisher kullanıldı diğerlerini kaldırabiliriz
 //imageSlider bir itemi yokmuş storyboardda koyamıyoruz kod ile oluşturulcak
 */
import UIKit
import ImageSlideshow
import ImageSlideshowKingfisher


class SnapVC: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    
    var selectedSnap : SnapModel?
    var inputArray = [KingfisherSource]()
    
    override func viewDidLoad() {
        super.viewDidLoad()


        
        //bu şekilde optiondan çıkarmış oluyoruz Option(...) gibi
        if let snap = selectedSnap {
            
            if let time = selectedSnap?.timeDifference {
                timeLabel.text = "Time Left: \(time)"
            }
           
            
            for imageUrl in snap.imageUrlArray {
                inputArray.append(KingfisherSource(urlString: imageUrl)!)
            }
            
            //çerçevesini hallettik
            let imageSlideShow = ImageSlideshow(frame: CGRect(x: 10, y: 10, width: self.view.frame.width * 0.95, height:  self.view.frame.height * 0.9))
            
            imageSlideShow.backgroundColor = UIColor.white
            
            //resimin altındaki resim sayısı hemde hangisinde olduğu gösterrir
            let pageIndicator = UIPageControl()
            //olan resim noktası rengini yaptık
            pageIndicator.currentPageIndicatorTintColor = UIColor.lightGray
            //olmayan resim noktası siyah olcak
            pageIndicator.pageIndicatorTintColor = UIColor.black
            imageSlideShow.pageIndicator = pageIndicator
            
            
            //resim tam oalrka verilmesini sağladık çekiştirme vs olmadan
            imageSlideShow.contentScaleMode = UIViewContentMode.scaleAspectFit
            
            imageSlideShow.setImageInputs(inputArray)
            self.view.addSubview(imageSlideShow)
            
            //label önde göstericektir
            self.view.bringSubviewToFront(timeLabel)
            
            
        }
        
        
       
        
        
    }
    



}
