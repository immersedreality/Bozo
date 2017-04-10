
import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func usernameButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func reloadButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func aboutButtonTapped(_ sender: UIButton) {
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
