
import UIKit

class AboutUsViewController: UITableViewController {
    
    var business = Business()
    var openHours = [String]()
    
    private var contacts = [String]()
    private var socialNetworks = [String]()
    
    private let CALL_US = "✆ Call us"
    private let SEND_EMAIL = "✉️ Send email"
    private let FACEBOOK = "• Follow us on Facebook"
    private let TWITTER = "• Follow us on Twitter"
    private let INSTAGRAM = "• Follow us on Instagram"
    private let PINTEREST = "• Follow us on Pinterest"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.isUserInteractionEnabled = true
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0 || section == 1) {
            return 1
        }
        else if (section == 2) {
            return openHours.count
        }
        else if (section == 3) {
            contacts = [CALL_US, SEND_EMAIL];
            return contacts.count
        }
        else if (section == 4) {
            socialNetworks = [FACEBOOK, TWITTER, INSTAGRAM, PINTEREST];
            return socialNetworks.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 2) {
            return "Open hours"
        }
        else if (section == 3) {
            return "Get in touch"
        }
        else if (section == 4) {
            return "Social networks"
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section != 0 && section != 1) {
            return 1.5 * tableView.sectionHeaderHeight
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = ColorHelper.shared.getColorFromHex("#FF9300", 1)
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 0) {
            return 200;
        }
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantImageCell", for: indexPath)
            cell.isUserInteractionEnabled = false
            cell.selectionStyle = .none
            cell.backgroundView = UIImageView.init(image: UIImage.init(named: "aboutUs.png"))
            cell.backgroundView?.contentMode = .scaleAspectFill
            return cell
        }
        else if (indexPath.section == 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantInfoCell", for: indexPath) as! RestaurantInfoCell
            cell.selectionStyle = .none
                cell.storeNameLabel.text = business.storeName
                cell.addressLabel.text = business.address
            return cell
        }
        else if (indexPath.section == 2) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OpenHoursCell", for: indexPath)
            cell.isUserInteractionEnabled = false
            cell.selectionStyle = .none
            if (openHours.count > 0) {
                cell.textLabel?.text = openHours[indexPath.row]
                cell.detailTextLabel?.text = stringFromWeekDay(indexPath.row)
            }
            return cell
        }
        
        else if (indexPath.section == 3) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath)
            cell.textLabel?.text = contacts[indexPath.row]
            return cell
        }
        else if (indexPath.section == 4) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SocialCell", for: indexPath)
            cell.textLabel?.text = socialNetworks[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 3) {
            if (indexPath.row == 0) {
                let phoneString = String(format:"telprompt://%@", (business.phoneNumber)!)
                UIApplication.shared.openURL(URL.init(string: phoneString)!)
            }
            else if (indexPath.row == 1) {
                let emailString = String(format:"mailto://%@", (business.email)!)
                UIApplication.shared.openURL(URL.init(string: emailString)!)
            }
        }
        else if (indexPath.section == 4) {
            var url: URL?
            if (indexPath.row == 0) {
                url = URL.init(string: (business.facebookPage)!)
            }
            else if (indexPath.row == 1) {
                url = URL.init(string: (business.twitterPage)!)
            }
            else if (indexPath.row == 2) {
                url = URL.init(string: (business.instagramPage)!)
            }
            else if (indexPath.row == 3) {
                url = URL.init(string: (business.pinterestPage)!)
            }
            UIApplication.shared.openURL(url!)
        }
    }
    
    func stringFromWeekDay(_ weekday: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.init(identifier: "en_US")
        return dateFormatter.weekdaySymbols[weekday]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let mapVC = segue.destination as! MapViewController
        mapVC.business = business
    }
}
