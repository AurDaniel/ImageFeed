import UIKit

class SingleImageViewController: UIViewController {
    
    @IBAction private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }
            singleImageView.image = image
        }
    }
    
    @IBOutlet var singleImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        singleImageView.image = image
    }
}
