

import UIKit

class GameCollectionTableViewController: UITableViewController {

    let manager = APIManager.singleton
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if manager.gameCollection.isEmpty {
            manager.getGames(completion: {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                if self.manager.gameCollection.isEmpty {
                    self.presentInternetErrorAlert()
                }
            })
        }
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manager.gameCollection.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath) as! GameTableViewCell
        cell.game = manager.gameCollection[indexPath.row]
        cell.gameTitleLabel.text = cell.game.title
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toGameDetailVC" {
            let indexPath = tableView.indexPathForSelectedRow
            let cell = tableView.cellForRow(at: indexPath!) as! GameTableViewCell
            let destination = segue.destination as! GameDetailViewController
            destination.game = cell.game
        }
    }
    
    func presentInternetErrorAlert() {
        let internetErrorAlert = UIAlertController(title: "There was an issue getting your board game data.", message: "Please check that your username is accurate and try reloading from the settings menu.", preferredStyle: .alert)
        let internetErrorAction = UIAlertAction(title: "Got it", style: .default) { (_) in
            self.dismiss(animated: true, completion: nil)
        }
        internetErrorAlert.addAction(internetErrorAction)
        present(internetErrorAlert, animated: true, completion: nil)
    }

    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
