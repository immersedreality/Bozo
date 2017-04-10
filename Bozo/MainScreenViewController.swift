
import UIKit

class MainScreenViewController: UIViewController {

    let defaults = UserDefaults.standard
    
    @IBOutlet weak var usernameLabel: UILabel!
    var username: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        username = defaults.string(forKey: "username")
        if username != nil {
            usernameLabel.text = username?.lowercased()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if username == nil {
            sleep(1)
            performSegue(withIdentifier: "toIntroductionVC", sender: nil)
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
