
import UIKit

class SettingsViewController: UIViewController {

    let defaults = UserDefaults.standard
    let manager = APIManager.singleton
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.isHidden = true
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func usernameButtonTapped(_ sender: UIButton) {
        presentUsernameEntryAlert()
    }
    
    @IBAction func reloadButtonTapped(_ sender: UIButton) {
        self.activityIndicator.startAnimating()
        self.activityIndicator.isHidden = false
        
        manager.getGames { (games) in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                
                guard !games.isEmpty else {
                    self.presentInternetErrorAlert()
                    return
                }
                
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func aboutButtonTapped(_ sender: UIButton) {
        guard let url = URL(string: "http://www.youtube.com//boardbozos") else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    func presentUsernameEntryAlert() {
        let usernameEntryAlert = UIAlertController(title: "Enter Your BGG Username", message: nil, preferredStyle: .alert)
        let usernameEntryCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let usernameEntryAction = UIAlertAction(title: "Snag games", style: .default) { (_) in
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
                        self.presentInternetErrorAlert()
                        return
                    }
                    
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }
        
        usernameEntryAlert.addTextField(configurationHandler: nil)
        usernameEntryAlert.addAction(usernameEntryCancel)
        usernameEntryAlert.addAction(usernameEntryAction)
        present(usernameEntryAlert, animated: true, completion: nil)
    }
    
    func presentInternetErrorAlert() {
        let internetErrorAlert = UIAlertController(title: "There was an issue getting your board game data.", message: "Board Game Geek may be busy.  Please check that your username is accurate and try again in a few moments.", preferredStyle: .alert)
        let internetErrorAction = UIAlertAction(title: "Got it", style: .default) { (_) in }
        internetErrorAlert.addAction(internetErrorAction)
        present(internetErrorAlert, animated: true, completion: nil)
    }
}
