
import UIKit

class HomeViewController: UITableViewController {
    
    private let backendless = Backendless.sharedInstance()!
    private let FAVORITES = "★ Favorites"
    private let SHOPPING_CART = "🛒 Shopping Cart"
    private let ABOUT = "ℹ About us"
    private let LOGOUT = "← Logout"
    private let ARTICLES = "📰 Articles"
    
    private var favoritesAndCart: [String]?
    private var categories: [String]?
    private var news: [String]?
    private var other: [String]?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()

        backendless.data.of(Category.ofClass()).find({ categoryArray in
            self.categories = [String]()
            for category in categoryArray! {
                self.categories?.append(String(format:"• %@", (category as! Category).title!))
            }
            self.tableView.reloadData()
        }, error: { fault in
            AlertViewController.showErrorAlert(fault!, self, nil)
        })
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            favoritesAndCart = [FAVORITES, SHOPPING_CART]
            return (favoritesAndCart?.count)!
        }
        else if (section == 1) {
            if (categories != nil) {
                return (categories?.count)!
            }
            return 0
        }
        else if (section == 2) {
            news = [ARTICLES]
            return (news?.count)!
        }
        else if (section == 3) {
            other = [ABOUT, LOGOUT]
            return (other?.count)!
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 1) {
            return "Categories"
        }
        else if (section == 2) {
            return "News"
        }
        else if (section == 3) {
            return "Other"
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section != 0) {
            return 1.5 * tableView.sectionHeaderHeight
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = ColorHelper.shared.getColorFromHex("#FF9300", 1)
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath)
        if (indexPath.section == 0) {
            cell.textLabel?.text = favoritesAndCart?[indexPath.row]
        }
        else if (indexPath.section == 1) {
            cell.textLabel?.text = categories?[indexPath.row]
        }
        else if (indexPath.section == 2) {
            cell.textLabel?.text = news?[indexPath.row]
        }
        else if (indexPath.section == 3) {
            cell.textLabel?.text = other?[indexPath.row]
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                performSegue(withIdentifier: "ShowItems", sender: cell)
            }
            else if (indexPath.row == 1) {
                performSegue(withIdentifier: "ShowCart", sender: cell)
            }
        }
        else if (indexPath.section == 1 || indexPath.section == 2) {
            self.performSegue(withIdentifier: "ShowItems", sender: cell)
        }
        else if (indexPath.section == 3 && cell?.textLabel?.text == LOGOUT) {
            self.performSegue(withIdentifier: "unwindToLoginVC", sender: cell)
        }
        else if (indexPath.section == 3 && cell?.textLabel?.text == ABOUT) {
            self.performSegue(withIdentifier: "ShowAbout", sender: cell)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)
        if (indexPath?.section == 0) {
            let navController = segue.destination as! UINavigationController
            if (segue.identifier == "ShowItems") {
                let itemsVC = navController.topViewController as! ItemsViewController
                itemsVC.navigationItem.title = "Favorites"
            }
        }
        else if (indexPath?.section == 1) {
            let navController = segue.destination as! UINavigationController
            let itemsVC = navController.topViewController as! ItemsViewController
            let title = cell.textLabel?.text!
            let indexStartOfText = title!.index(title!.startIndex, offsetBy: 2)
            itemsVC.navigationItem.title = String(title![indexStartOfText...])
        }
        else if (indexPath?.section == 2) {
            let navController = segue.destination as! UINavigationController
            let itemsVC = navController.topViewController as! ItemsViewController
            itemsVC.navigationItem.title = "News"
        }
        else if (indexPath?.section == 3 && segue.identifier == "ShowAbout") {
            backendless.data.of(Business.ofClass()).findFirst({ business in
                self.backendless.data.of(OpenHoursInfo.ofClass()).find({ openHours in
                    let navController = segue.destination as! UINavigationController
                    let aboutUsVC = navController.topViewController as! AboutUsViewController
                    aboutUsVC.business = business as? Business
                    aboutUsVC.openHours = self.sortedOpenHours(openHours as! [OpenHoursInfo])
                    aboutUsVC.tableView.reloadData()
                }, error: { fault in
                    AlertViewController.showErrorAlert(fault!, self, nil)
                })
            }, error: { fault in
                AlertViewController.showErrorAlert(fault!, self, nil)
            })
        }
    }
    
    func sortedOpenHours(_ openHours: [OpenHoursInfo]) -> [String] {
        let sortedOpenHours = openHours.sorted { (($0.day?.intValue)!, ($0.openAt)!) < (($1.day?.intValue)!, ($1.openAt)!) }
        var openHoursStrings = [String]()
        for index in 0...6 {
            openHoursStrings.insert("", at: index)
        }
        for openHoursInfo in sortedOpenHours {
            let day = openHoursInfo.day
            let openAt = openHoursInfo.openAt
            let closeAt = openHoursInfo.closeAt
            let index = (day?.intValue)! - 1
            
            if ((openHoursStrings[index].isEmpty)) {
                let hours = String(format: "%@ - %@", stringFromDate(openAt!), stringFromDate(closeAt!))
                openHoursStrings[index] = hours
                
            }
            else {
                var hours = openHoursStrings[index]
                hours.append(String(format: " / %@ - %@", stringFromDate(openAt!), stringFromDate(closeAt!)))
                openHoursStrings[index] = hours
            }
        }
        for index in 0...6 {
            if (openHoursStrings[index].isEmpty) {
                openHoursStrings[index] = "Closed"
            }
        }
        return openHoursStrings
    }
    
    func stringFromDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
    
    @IBAction func unwindToHomeVC(segue:UIStoryboardSegue) {
    }
}
