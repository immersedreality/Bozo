
import UIKit

class MainScreenViewController: UIViewController {

    let defaults = UserDefaults.standard
    var manager = APIManager.singleton

    @IBOutlet weak var usernameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let username = defaults.string(forKey: "username") {
            manager.username = username
            manager.getGames(completion: {})
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let username = manager.username {
            usernameLabel.text = username.lowercased()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if defaults.string(forKey: "username") == nil {
            sleep(1)
            performSegue(withIdentifier: "toIntroductionVC", sender: nil)
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
