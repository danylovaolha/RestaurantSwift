
import UIKit

class DeliveryMethodsViewController: UITableViewController {
    
    private let HOME_DELIVERY = "🚗 Home delivery"
    private let TAKE_AWAY = "🥡 Take away"
    private let DINE_IN = "🍽 Dine in"
    var deliveryMethods = [DeliveryMethod]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deliveryMethods.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeliveryMethodCell", for: indexPath)
        let deliveryMethod = deliveryMethods[indexPath.row]
        cell.textLabel?.text = deliveryMethod.name
        cell.detailTextLabel?.text = deliveryMethod.details
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        performSegue(withIdentifier: "ShowDeliveryMethod", sender: cell)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = tableView.indexPath(for: sender as! UITableViewCell)! as NSIndexPath
        let deliveryMethod = deliveryMethods[indexPath.row]
        let deliveryVC = segue.destination as! DeliveryViewController
        deliveryVC.navigationItem.title = deliveryMethod.name
        deliveryVC.deliveryMethodName = deliveryMethod.name!
        deliveryVC.inputFields = deliveryMethod.inputFields as! [DeliveryInputField]
        Backendless.sharedInstance().data.of(Business.ofClass()).findFirst({ business in
            deliveryVC.business = business as! Business
            deliveryVC.tableView.reloadData()
        }, error: { fault in
            AlertViewController.showErrorAlert(fault!, self, nil)
        })
    }
}
