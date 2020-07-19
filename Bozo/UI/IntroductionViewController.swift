
import UIKit

class IntroductionViewController: UIViewController {

    let defaults = UserDefaults.standard
    let manager = APIManager.singleton

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
    }
    
    @IBAction func letsGoButtonTapped(_ sender: UIButton) {
        presentUsernameEntryAlert()
    }
    
    func presentUsernameEntryAlert() {
        let usernameEntryAlert = UIAlertController(title: "Enter Your BGG Username", message: nil, preferredStyle: .alert)
        let usernameEntryAction = UIAlertAction(title: "Here you go!", style: .default) { (_) in
            self.activityIndicator.startAnimating()
            self.activityIndicator.isHidden = false
            
            let username = usernameEntryAlert.textFields?[0].text
            self.defaults.set(username, forKey: "username")
            self.manager.username = username
            self.manager.getGames(completion: { (games) in
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    
                    guard !games.isEmpty else {
                        let internetErrorAlert = UIAlertController(title: "There was an issue getting your board game data.", message: "Board Game Geek may be busy.  Please check that your username is accurate and try again in a few moments.", preferredStyle: .alert)
                        let internetErrorAction = UIAlertAction(title: "Got it", style: .default) { (_) in }
                        internetErrorAlert.addAction(internetErrorAction)
                        self.present(internetErrorAlert, animated: true, completion: nil)
                        return
                    }
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }
        
        usernameEntryAlert.addTextField(configurationHandler: nil)
        usernameEntryAlert.addAction(usernameEntryAction)
        present(usernameEntryAlert, animated: true, completion: nil)
    }
}
