
import UIKit

class ItemInfoCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!  
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        var layoutMargins: UIEdgeInsets {
            get { return UIEdgeInsets.zero }
        }
    }
}

