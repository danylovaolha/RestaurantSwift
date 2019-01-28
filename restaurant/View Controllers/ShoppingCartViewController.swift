
import UIKit

class ShoppingCartViewController: UITableViewController {
    
    @IBOutlet weak var proceedToPaymentButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        ShoppingCart.shared.totalPrice = 0
        ShoppingCart.shared.shoppingCartItems = UserDefaultsHelper.shared.getShoppingCartItems()
        proceedToPaymentButtonEnabled()
    }
    
    func proceedToPaymentButtonEnabled() {
        if (ShoppingCart.shared.shoppingCartItems.count > 0) {
            proceedToPaymentButton.isEnabled = true
        }
        else {
            proceedToPaymentButton.isEnabled = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setToolbarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setToolbarHidden(true, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ShoppingCart.shared.shoppingCartItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {      
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingCartCell", for: indexPath) as! ShoppingCartCell
        let shoppingCartItem = ShoppingCart.shared.shoppingCartItems[indexPath.row]
        
        cell.quantityTextField.text = String(format: "%@", shoppingCartItem.quantity!)
        cell.shoppingCartItem = shoppingCartItem
        cell.titleLabel.text = shoppingCartItem.menuItem?.title
        cell.descriptionLabel.text = shoppingCartItem.menuItem?.body
        
        let picture = shoppingCartItem.menuItem?.pictures?.firstObject
        if (picture != nil && picture is Picture) {
            PictureHelper.shared.setSmallImageFromUrl((picture as! Picture).url!, cell)
        }
        let price = shoppingCartItem.menuItem?.prices?.firstObject
        if (price != nil && price is Price) {
            cell.sizeAndQuantityLabel.text = String(format:"%@%.2f x %@ %@", (price as! Price).currency!,
                                                    ((price as! Price).value?.doubleValue)!, shoppingCartItem.quantity!, (price as! Price).name!)
        }
        
        let predicate = NSPredicate.init(format: "selected = 1")
        let standardOptions = shoppingCartItem.menuItem?.standardOptions?.filtered(using: predicate)
        let extraOptions = shoppingCartItem.menuItem?.extraOptions?.filtered(using: predicate)
        
        var optionsString = ""
        for standardOption in standardOptions! {
            optionsString.append(String(format: "%@: $0\n", (standardOption as! StandardOption).name!))
        }
        for extraOption in extraOptions! {
            optionsString.append(String(format: "%@: $%.2f\n", (extraOption as! ExtraOption).name!, (extraOption as! ExtraOption).value!.doubleValue))
        }
        if (!optionsString.isEmpty) {
            optionsString.removeLast(1)
        }
        cell.optionsLabel.text = optionsString
        cell.totalLabel.text = String(format: "Total: %@%.2f", (price as! Price).currency!, (shoppingCartItem.price?.doubleValue)! * (shoppingCartItem.quantity?.doubleValue)!)
        ShoppingCart.shared.totalPrice = NSNumber.init(value: (shoppingCartItem.price?.doubleValue)! * (shoppingCartItem.quantity?.doubleValue)! + (ShoppingCart.shared.totalPrice?.doubleValue)!)
        proceedToPaymentButton.title = String(format: "Proceed to payment: $%.2f", ShoppingCart.shared.totalPrice!.doubleValue)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let shoppingCartItem = ShoppingCart.shared.shoppingCartItems[indexPath.row]
            UserDefaultsHelper.shared.removeItemFromShoppingCart(shoppingCartItem.menuItem!)
            ShoppingCart.shared.totalPrice = 0
            ShoppingCart.shared.shoppingCartItems = UserDefaultsHelper.shared.getShoppingCartItems()
            proceedToPaymentButton.title = String(format: "Proceed to payment: $%@", ShoppingCart.shared.totalPrice!)
            proceedToPaymentButtonEnabled()
            tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        Backendless.sharedInstance().data.of(DeliveryMethod.ofClass()).find({ deliveryMethods in
            let deliveryMethodVC = segue.destination as! DeliveryMethodsViewController
            deliveryMethodVC.deliveryMethods = deliveryMethods as! [DeliveryMethod]
            deliveryMethodVC.tableView.reloadData()
        }, error: { fault in
            AlertViewController.showErrorAlert(fault!, self, nil)
            
        })
    }
}


