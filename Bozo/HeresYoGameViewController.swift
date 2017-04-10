
import UIKit

class HeresYoGameViewController: UIViewController {

    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var gameTitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func notThisButtonTapped(_ sender: UIButton) {
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
