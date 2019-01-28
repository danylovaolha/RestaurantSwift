
import UIKit

class AlertViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    class func showErrorAlert(_ fault: Fault, _ target: UIViewController, _ actionHandler:((UIAlertAction) -> Void)?) {
        var errorTitle = "Error"
        if (fault.faultCode != nil) {
            errorTitle = String(format:"Error %@", fault.faultCode)
        }
        let alert = UIAlertController.init(title: errorTitle, message: fault.message, preferredStyle: .alert)
        alert.view.tintColor = ColorHelper.shared.getColorFromHex("#FF9300", 1)
        let dismissAction = UIAlertAction.init(title: "Dismiss", style: .cancel, handler: actionHandler)
        alert.addAction(dismissAction)
        target.present(alert, animated: true, completion: nil)
    }
    
    class func showAlertWithTitle(_ title: String, _ message: String, _ target: UIViewController, _ actionHandler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alert.view.tintColor = ColorHelper.shared.getColorFromHex("#FF9300", 1)
        let chatsAction = UIAlertAction.init(title: "OK", style: .default, handler: actionHandler)
        alert.addAction(chatsAction)
        target.present(alert, animated: true, completion: nil)
    }
    
    class func showAddedToCartAlert(_ title: String, _ message: String, _ target: UIViewController, _ actionHandler1: ((UIAlertAction) -> Void)?, _ actionHandler2: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alert.view.tintColor = ColorHelper.shared.getColorFromHex("#FF9300", 1)
        let contitueShopping = UIAlertAction.init(title: "Back", style: .default, handler: actionHandler1)
        alert.addAction(contitueShopping)
        let goToCart = UIAlertAction.init(title: "Go to cart", style: .default, handler: actionHandler2)
        alert.addAction(goToCart)
        target.present(alert, animated: true, completion: nil)
    }
    
    class func showSendEmailAlert(_ title: String, _ body: String, _ target: UIViewController, _ actionHandler: (() -> Void)?) {
        let alert = UIAlertController.init(title: "Send order confirmation", message: "Input your email", preferredStyle: .alert)
        alert.view.tintColor = ColorHelper.shared.getColorFromHex("#FF9300", 1)
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "email"
            textField.clearButtonMode = UITextField.ViewMode.whileEditing
        })
        let confirmAction = UIAlertAction.init(title: "Confirm", style: .default, handler: { sendConfirmation in
            if let textField = alert.textFields?.first {
                if ((textField.text?.count)! > 0) {
                    Backendless.sharedInstance().messaging.sendTextEmail(title, body: body, to: [textField.text!], response: { status in
                        actionHandler!()
                    }, error: { fault in
                        self.showErrorAlert(fault!, target, nil)
                    })
                }
            }
        })
        alert.addAction(confirmAction)
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        target.present(alert, animated: true, completion: nil)
    }
}

