
import UIKit

class ImagesViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        NetworkInteractor.fetchImages(completion: { })
    }
}
