
import UIKit

class SizeAndPriceCell: UITableViewCell {

    @IBOutlet weak var sizeAndPriceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        var layoutMargins: UIEdgeInsets {
            get { return UIEdgeInsets.zero }
        }
    }    
}
