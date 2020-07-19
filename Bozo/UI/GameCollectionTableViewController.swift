

import UIKit

class GameCollectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let manager = APIManager.singleton
    
    @IBOutlet weak var gamesTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gamesTableView.estimatedRowHeight = 100
        gamesTableView.rowHeight = UITableView.automaticDimension
        gamesTableView.delegate = self
        gamesTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.activityIndicator.isHidden = true
        gamesTableView.reloadData()
        
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
                    self.gamesTableView.reloadData()
                }
            })
        }
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manager.gameCollection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath) as! GameTableViewCell
        cell.game = manager.gameCollection[indexPath.row]
        cell.gameTitleLabel.text = cell.game.title
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toGameDetailVC" {
            let indexPath = gamesTableView.indexPathForSelectedRow
            let cell = gamesTableView.cellForRow(at: indexPath!) as! GameTableViewCell
            let destination = segue.destination as! GameDetailViewController
            destination.game = cell.game
        }
    }
    
    func presentInternetErrorAlert() {
        let internetErrorAlert = UIAlertController(title: "There was an issue getting your board game data.", message: "Board Game Geek may be busy.  Please check that your username is accurate and try again in a few moments.", preferredStyle: .alert)
        let internetErrorAction = UIAlertAction(title: "Got it", style: .default) { (_) in
            self.dismiss(animated: true, completion: nil)
            
        }
        internetErrorAlert.addAction(internetErrorAction)
        present(internetErrorAlert, animated: true, completion: nil)
    }
}
