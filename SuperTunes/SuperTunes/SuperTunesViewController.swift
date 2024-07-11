import UIKit

// Main ViewController for the SuperTunes app
class SuperTunesViewController: UIViewController {

    // Outlets for the search bar and table view
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    // Variables to hold search results, track search status, and loading status
    var searchResults = [SuperTunes]()
    var hasSearched = false
    var isLoading = false

    // ViewDidLoad lifecycle method
    override func viewDidLoad() {
        super.viewDidLoad()

        // Adjust table view content inset
        tableView.contentInset = UIEdgeInsets(top: 51, left: 0, bottom: 0, right: 0)
        
        // Register nib files for different cell types
        var cellNib = UINib(nibName: TableView.CellIdentifiers.superTunesCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.superTunesCell)
        
        cellNib = UINib(nibName: TableView.CellIdentifiers.nothingFoundCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.nothingFoundCell)
        
        cellNib = UINib(nibName: TableView.CellIdentifiers.loadingCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.loadingCell)
        
        // Make the search bar active
        searchBar.becomeFirstResponder()
    }
    
    // Struct to hold cell identifiers for easy reference
    struct TableView {
        struct CellIdentifiers {
            static let superTunesCell = "SuperTunesCell"
            static let nothingFoundCell = "NothingFoundCell"
            static let loadingCell = "LoadingCell"
        }
    }
    
    // Helper method to create iTunes search URL
    func iTunesURL(searchText: String) -> URL {
        let encodedText = searchText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let urlString = String(format: "https://itunes.apple.com/search?term=%@&limit=200", encodedText)
        let url = URL(string: urlString)
        return url!
    }
    
    // Helper method to perform network request and fetch data
    func performStoreRequest(with url: URL) -> Data? {
        do {
            return try Data(contentsOf: url)
        } catch {
            print("Download Error: \(error.localizedDescription)")
            showNetworkError()
            return nil
        }
    }
    
    // Helper method to parse JSON data into an array of SuperTunes objects
    func parse(data: Data) -> [SuperTunes] {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(ResultArray.self, from: data)
            return result.results
        } catch {
            print("JSON Error: \(error)")
            return []
        }
    }

    // Helper method to display a network error alert
    func showNetworkError() {
        let alert = UIAlertController(title: "Whoops...", message: "There was an error accessing the SuperTunes Store. Please try again.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - Search Bar Delegate
extension SuperTunesViewController: UISearchBarDelegate {
    // Method called when the search button is clicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !searchBar.text!.isEmpty {
            searchBar.resignFirstResponder()

            // Start loading animation and clear previous search results
            isLoading = true
            tableView.reloadData()
            hasSearched = true
            searchResults = []

            // Create a background queue for network request
            let queue = DispatchQueue.global()
            let url = self.iTunesURL(searchText: searchBar.text!)
            
            queue.async {
                if let data = self.performStoreRequest(with: url) {
                    // Parse and sort the search results
                    self.searchResults = self.parse(data: data)
                    self.searchResults.sort(by: <)
                    DispatchQueue.main.async {
                        // Stop loading animation and reload table view with new data
                        self.isLoading = false
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }

    // Method to position the search bar
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}

// MARK: - Table View Delegate
extension SuperTunesViewController: UITableViewDelegate, UITableViewDataSource {
    // Method to determine number of rows in the table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading {
            return 1
        } else if !hasSearched {
            return 0
        } else if searchResults.count == 0 {
            return 1
        } else {
            return searchResults.count
        }
    }

    // Method to configure and return cell for a given index path
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoading {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.loadingCell, for: indexPath)
            let spinner = cell.viewWithTag(100) as! UIActivityIndicatorView
            spinner.startAnimating()
            return cell
        } else if searchResults.count == 0 {
            return tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.nothingFoundCell, for: indexPath)
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.superTunesCell, for: indexPath) as! SuperTunesCell
            let searchResult = searchResults[indexPath.row]
            cell.trackLabel.text = searchResult.name
            if searchResult.artist.isEmpty {
                cell.artistNameLabel.text = "Unknown"
            } else {
                cell.artistNameLabel.text = String(format: "%@ (%@)", searchResult.artist, searchResult.type)
            }
            return cell
        }
    }

    // Method called when a table view cell is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // Method to determine if a row should be selectable
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if searchResults.count == 0 || isLoading {
            return nil
        } else {
            return indexPath
        }
    }
}

