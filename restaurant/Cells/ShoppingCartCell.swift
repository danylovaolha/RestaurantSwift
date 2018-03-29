
import UIKit

class ShoppingCartCell: UITableViewCell {
    
    @IBOutlet weak var pictureView: UIImageView!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var sizeAndQuantityLabel: UILabel!
    @IBOutlet weak var optionsLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    var shoppingCartItem: ShoppingCartItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func pressedDecreaseQuantity(_ sender: Any) {
    }    
    
    @IBAction func pressedIncreaseQuantity(_ sender: Any) {
    }
    
}
