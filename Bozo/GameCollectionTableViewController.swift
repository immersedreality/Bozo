

import UIKit

class GameCollectionTableViewController: UITableViewController {

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
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
