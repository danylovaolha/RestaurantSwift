
import UIKit

class AboutUsViewController: UITableViewController {
    
    var business: Business?
    var openHours: [String : Any]?
    
    private var contacts: [String]?
    private var socialNetworks: [String]?
    
    private let CALL_US = "✆ Call us"
    private let SEND_EMAIL = "✉️ Send email"
    private let FACEBOOK = "• Follow us on Facebook"
    private let TWITTER = "• Follow us on Twitter"
    private let INSTAGRAM = "• Follow us on Instagram"
    private let PINTEREST = "• Follow us on Pinterest"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0 || section == 1) {
            return 1
        }
        else if (section == 2) {
            return (openHours?.count)!
        }
        else if (section == 3) {
            contacts = [CALL_US, SEND_EMAIL];
            return (contacts?.count)!
        }
        else if (section == 4) {
            socialNetworks = [FACEBOOK, TWITTER, INSTAGRAM, PINTEREST];
            return (socialNetworks?.count)!
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
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantImageCell", for: indexPath)
            cell.isUserInteractionEnabled = false
            cell.selectionStyle = .none
            cell.backgroundView = UIImageView.init(image: UIImage.init(named: "waitingImage.png"))
            cell.backgroundView?.contentMode = .scaleAspectFill
            let randomIndex = Int(arc4random_uniform(UInt32((business?.welcomeImages?.count)!)))
            let picture = self.business?.welcomeImages![randomIndex] as! Picture
            if (UserDefaultsHelper.shared.getImageFromUserDefaults(picture.url!) != nil) {
                cell.backgroundView = UIImageView.init(image: UserDefaultsHelper.shared.getImageFromUserDefaults(picture.url!))
                cell.backgroundView?.contentMode = .scaleAspectFill
            }
                
                // *********************************
            else {
                DispatchQueue.global(qos: .default).async(execute: {() -> Void in
                    
                    
                    
                    DispatchQueue.main.async(execute: {() -> Void in
                        
                    })
                })
            }
            // ***************************************
            
            
            return cell
        }
        return UITableViewCell()
    }
    
    /*
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
     UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:picture.url]]];
     if (image && picture.url) {
     NSLog(@"%@, %@", image, picture.url);
     [userDefaultsHelper saveImageToUserDefaults:image withKey:picture.url];
     }
     dispatch_async(dispatch_get_main_queue(), ^{
     cell.backgroundView = [[UIImageView alloc] initWithImage:image];
     cell.backgroundView.contentMode = UIViewContentModeScaleAspectFill;
     });
     });
     }
     return cell;
     }
     else if (indexPath.section == 1) {
     RestaurantInfoCell *cell = (RestaurantInfoCell *)[tableView dequeueReusableCellWithIdentifier:@"RestaurantInfoCell"];
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
     cell.storeNameLabel.text = self.business.storeName;
     cell.addressLabel.text = self.business.address;
     cell.descLabel.text = self.business.desc;
     return cell;
     }
     else if (indexPath.section == 2) {
     UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"OpenHoursCell"];
     cell.userInteractionEnabled = NO;
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
     cell.textLabel.text = [[self.openHours allKeys] objectAtIndex:indexPath.row];
     cell.detailTextLabel.text = [self.openHours objectForKey:[[self.openHours allKeys] objectAtIndex:indexPath.row]];
     return cell;
     }
     else if (indexPath.section == 3) {
     UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ContactCell"];
     cell.textLabel.text = [contacts objectAtIndex:indexPath.row];
     return cell;
     }
     else if (indexPath.section == 4) {
     UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"SocialCell"];
     cell.textLabel.text = [socialNetworks objectAtIndex:indexPath.row];
     return cell;
     }
     return nil;
     }*/
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
