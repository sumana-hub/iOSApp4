import UIKit

// Custom UITableViewCell subclass for displaying SuperTunes search results
class SuperTunesCell: UITableViewCell {
    
    // Outlets for the UI elements in the cell
    @IBOutlet weak var trackLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var artworkImageView: UIImageView!

    // Called when the cell is loaded from the nib
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Customize the selected background view of the cell
        let selectedView = UIView(frame: CGRect.zero)
        selectedView.backgroundColor = UIColor(named: "SearchBar")?.withAlphaComponent(0.5)
        selectedBackgroundView = selectedView
    }

    // Called when the cell's selected state is changed
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state (if needed)
    }
}

