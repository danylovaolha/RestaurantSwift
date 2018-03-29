
import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet weak var pictureView: UIImageView!    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.text = ""
        descriptionLabel.text = ""
    }
}
