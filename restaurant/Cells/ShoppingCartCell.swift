
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
    
    func saveChangedQuantity(_ sender: Any, _ quantity: Int) {
        shoppingCartItem?.quantity = NSNumber.init(value: quantity)
        
        print(shoppingCartItem?.quantity)
        
        let buttonPosition = (sender as! UIButton).convert(CGPoint.zero, to: self.superview)
        let indexPath = (self.superview as! UITableView).indexPathForRow(at: buttonPosition)
        UserDefaultsHelper.shared.saveShoppingCartItem(shoppingCartItem!, (indexPath?.row)!)
        quantityTextField.text = String(format: "%@", (shoppingCartItem?.quantity)!)
        ShoppingCart.shared.totalPrice = 0
        (self.superview as! UITableView).reloadData()
    }
    
    @IBAction func pressedDecreaseQuantity(_ sender: Any) {
        var quantity = shoppingCartItem?.quantity?.intValue
        if (quantity! >= 2) {
            quantity = quantity! - 1
        }
        saveChangedQuantity(sender, quantity!)
    }    
    
    @IBAction func pressedIncreaseQuantity(_ sender: Any) {
        var quantity = shoppingCartItem?.quantity?.intValue
        quantity = quantity! + 1
        saveChangedQuantity(sender, quantity!)
    }
}
