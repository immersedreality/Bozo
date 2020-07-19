
import UIKit

class MainScreenViewController: UIViewController {

    
    let defaults = UserDefaults.standard
    var manager = APIManager.singleton

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.isHidden = true
        
        if let username = defaults.string(forKey: "username") {
            manager.username = username
            
            if manager.gameCollection.isEmpty {
                self.activityIndicator.startAnimating()
                self.activityIndicator.isHidden = false
                
                manager.getGames(completion: { (games) in
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.isHidden = true
                        
                        guard !games.isEmpty else {
                            self.presentInternetErrorAlert()
                            return
                        }
                    }
                })
            }
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
    
    func presentInternetErrorAlert() {
        let internetErrorAlert = UIAlertController(title: "There was an issue getting your board game data.", message: "Board Game Geek may be busy.  Please check that your username is accurate and try again in a few moments.", preferredStyle: .alert)
        let internetErrorAction = UIAlertAction(title: "Got it", style: .default) { (_) in }
        internetErrorAlert.addAction(internetErrorAction)
        present(internetErrorAlert, animated: true, completion: nil)
    }
}
