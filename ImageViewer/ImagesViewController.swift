
import UIKit

class ImagesViewController: UIViewController {
    var images: [USAImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        NetworkInteractor.fetchImages() { images in
            self.images = images
            print(images)
        }
    }
}
