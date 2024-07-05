
import UIKit

class SuperTunesViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    var searchResults = [SuperTunes]()
    var hasSearched = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 51, left: 0, bottom: 0, right: 0)

        let cellNib = UINib(nibName: "SuperTunesCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "SuperTunesCell")

    }

    struct TableView {
      struct CellIdentifiers {
        static let searchResultCell = "SuperTunesCell"
      }
    }

}

// MARK: - Search Bar Delegate
extension SuperTunesViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
      searchBar.resignFirstResponder()
      searchResults = []
        if searchBar.text! != "justin bieber" {
            for i in 0...2 {
                let searchResult = SuperTunes()
                searchResult.trackName = String(format: "Fake Result %d for", i)
                searchResult.artistName = searchBar.text!
                searchResults.append(searchResult)
            }
        }
      hasSearched = true
      tableView.reloadData()
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
      return .topAttached
    }
}

// MARK: - Table View Delegate
extension SuperTunesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(
      _ tableView: UITableView,
      numberOfRowsInSection section: Int
    ) -> Int {
      if !hasSearched {
        return 0
      } else if searchResults.count == 0 {
        return 1
      } else {
        return searchResults.count
      }
    }

    func tableView(
      _ tableView: UITableView,
      cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
      let cellIdentifier = "SuperTunesCell"
      let cell = tableView.dequeueReusableCell(
        withIdentifier: cellIdentifier,
        for: indexPath) as! SuperTunesCell
      if searchResults.count == 0 {
        cell.trackLabel.text = "(Nothing found)"
        cell.artistNameLabel.text = ""
      } else {
        let searchResult = searchResults[indexPath.row]
        cell.trackLabel.text = searchResult.trackName
        cell.artistNameLabel.text = searchResult.artistName
      }
      return cell
    }

    
    func tableView(
      _ tableView: UITableView,
      didSelectRowAt indexPath: IndexPath
    ) {
      tableView.deselectRow(at: indexPath, animated: true)
    }
      
    func tableView(
      _ tableView: UITableView,
      willSelectRowAt indexPath: IndexPath
    ) -> IndexPath? {
      if searchResults.count == 0 {
        return nil
      } else {
        return indexPath
      }
    }


}

