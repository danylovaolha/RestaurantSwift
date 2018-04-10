
import UIKit

class DeliveryViewController: UITableViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var confirmButton: UIBarButtonItem!
    var business = Business()
    var deliveryMethodName = ""
    var inputFields = [DeliveryInputField]()
    
    private var readyToSendEmail = true
    private var singleLineInputFields = [DeliveryInputField]()
    private var multiLineInputFields = [DeliveryInputField]()
    private var singleLineInputFieldsDictionary = [String : String]()
    private var multiLineInputFieldsDictionary = [String : String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .onDrag
        confirmButton.title = String(format:"Confirm: $%.2f", (ShoppingCart.shared.totalPrice?.doubleValue)!)
        singleLineInputFields = inputFields.filter({ $0.multilineInput == 0 })
        multiLineInputFields = inputFields.filter({ $0.multilineInput == 1 })
        for inputField in singleLineInputFields {
            singleLineInputFieldsDictionary[inputField.title!] = ""
        }
        for inputField in multiLineInputFields {
            multiLineInputFieldsDictionary[inputField.title!] = ""
        }
        readyToSendEmail = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setToolbarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setToolbarHidden(true, animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return 1
        }
        else if (section == 1) {
            return singleLineInputFields.count
        }
        else if (section == 2) {
            return multiLineInputFields.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 0) {
            return 200
        }
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantInfoCell", for: indexPath) as! RestaurantInfoCell
            cell.storeNameLabel.text = business.storeName
            cell.addressLabel.text = business.address
            return cell
        }
        else if (indexPath.section == 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell", for: indexPath) as! TextFieldCell
            cell.textField.placeholder = singleLineInputFields[indexPath.row].title
            cell.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            return cell
        }
        else if (indexPath.section == 2) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextViewCell", for: indexPath) as! TextViewCell
            cell.textView.delegate = self
            cell.textView.text = multiLineInputFields[indexPath.row].title
            cell.textView.textColor = ColorHelper.shared.getColorFromHex("#C7C7CD", 1)
            return cell
        }
        return UITableViewCell()
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        singleLineInputFieldsDictionary[textField.placeholder!] = textField.text
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.becomeFirstResponder()
        return false
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        let indexPath = tableView.indexPath(for: textView.superview?.superview as! UITableViewCell)!
        if (textView.text == multiLineInputFields[indexPath.row].title) {
            textView.text = ""
            textView.textColor = ColorHelper.shared.getColorFromHex("#2C3E50", 1)
        }
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if (textView.text.isEmpty) {
            let indexPath = tableView.indexPath(for: textView.superview?.superview as! UITableViewCell)!
            textView.text = multiLineInputFields[indexPath.row].title
            textView.textColor = ColorHelper.shared.getColorFromHex("#C7C7CD", 1)
        }
        textView.resignFirstResponder()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let indexPath = tableView.indexPath(for: textView.superview?.superview as! UITableViewCell)!
        if (textView.text.isEmpty) {
            textView.text = multiLineInputFields[indexPath.row].title
            textView.textColor = ColorHelper.shared.getColorFromHex("#C7C7CD", 1)
            textView.becomeFirstResponder()
        }
        else {
            multiLineInputFieldsDictionary[multiLineInputFields[indexPath.row].title!] = textView.text
        }
        let currentOffset = tableView.contentOffset
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
        tableView.setContentOffset(currentOffset, animated: false)
        tableView.scrollToRow(at: NSIndexPath.init(row: 0, section: 2) as IndexPath, at: .bottom, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ShowMap") {
            let mapVC = segue.destination as! MapViewController
            mapVC.business = business
        }
    }
    
    @IBAction func pressedConfirmButton(_ sender: Any) {
        var emailText = String(format: "%@\n%@\n%@\n\nYou have ordered a %@\n\nOrdered items:",
                               (business.storeName)!, (business.address)!, (business.phoneNumber)!, deliveryMethodName)
        for item in ShoppingCart.shared.shoppingCartItems {
            var itemOptions = ""
            for option in (item.menuItem?.standardOptions)! {
                if ((option as! StandardOption).selected == 1) {
                    itemOptions.append(String(format: "%@, ", (option as! StandardOption).name!))
                }
            }
            for option in (item.menuItem?.extraOptions)! {
                if ((option as! ExtraOption).selected == 1) {
                    itemOptions.append(String(format: "%@, ", (option as! ExtraOption).name!))
                }
            }
            if (itemOptions.count >= 2) {
                itemOptions.removeLast(2)
                emailText.append(String(format: "\n• %@(%@) = %@ x $%.2f", (item.menuItem?.title)!, itemOptions, item.quantity!, (item.price?.doubleValue)!))
            }
            else {
                emailText.append(String(format: "\n• %@ = %@ x $%.2f", (item.menuItem?.title)!, item.quantity!, (item.price?.doubleValue)!))
            }
            
            
        }
        emailText.append(String(format: "\n----------\nTotal:$%.2f\n\nCustomers' info:", (ShoppingCart.shared.totalPrice?.doubleValue)!))
        
        for field in singleLineInputFieldsDictionary.keys {
            let value = singleLineInputFieldsDictionary[field]
            if (value?.isEmpty)! {
                let fault = Fault.fault("Field '\(field)' is required") as! Fault
                AlertViewController.showErrorAlert(fault, self, nil)
                readyToSendEmail = false
                break
            }
            else {
                emailText.append(String(format: "\n• %@: %@", field, singleLineInputFieldsDictionary[field]!))
                readyToSendEmail = true
            }
        }
        
        for field in multiLineInputFieldsDictionary.keys {
            let value = multiLineInputFieldsDictionary[field]
            if (!(value?.isEmpty)!) {
                emailText.append(String(format: "\n• %@: %@", field, multiLineInputFieldsDictionary[field]!))
            }
        }
        if (readyToSendEmail) {
            AlertViewController.showSendEmailAlert("Order confirmation", emailText, self, {
                AlertViewController.showAlertWithTitle("Order confirmation", "Confirmation send", self, { action in
                    ShoppingCart.shared.clearCart()
                    print(UserDefaultsHelper.shared.getShoppingCartItems())
                    self.performSegue(withIdentifier: "unwindToItemsVC", sender: nil)
                })
            })
        }
    }
}
