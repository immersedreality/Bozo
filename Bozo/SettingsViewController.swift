
import UIKit

class SettingsViewController: UIViewController {

    let defaults = UserDefaults.standard
    let manager = APIManager.singleton
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if manager.gameCollection.isEmpty {
            manager.getGames()
        }
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func usernameButtonTapped(_ sender: UIButton) {
        presentUsernameEntryAlert()
    }
    
    @IBAction func reloadButtonTapped(_ sender: UIButton) {
        manager.getGames()
    }
    
    @IBAction func aboutButtonTapped(_ sender: UIButton) {
        UIApplication.shared.openURL(URL(string: "http://www.youtube.com//boardbozos")!)
    }
    
    func presentUsernameEntryAlert() {
        let usernameEntryAlert = UIAlertController(title: "Enter Your BGG Username", message: nil, preferredStyle: .alert)
        let usernameEntryAction = UIAlertAction(title: "Snag my games!", style: .default) { (_) in
            let username = usernameEntryAlert.textFields?[0].text
            self.defaults.set(username, forKey: "username")
            self.manager.username = username
            self.manager.getGames()
            self.dismiss(animated: true, completion: nil)
        }
        
        usernameEntryAlert.addTextField(configurationHandler: nil)
        usernameEntryAlert.addAction(usernameEntryAction)
        present(usernameEntryAlert, animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
