
import UIKit

class ItemDetailsViewController: UITableViewController {

    @IBOutlet var table: UITableView!
    @IBOutlet weak var cartButton: UIBarButtonItem!
    @IBOutlet weak var addToFavoritesButton: UIBarButtonItem!
    @IBOutlet weak var addToCartButton: UIBarButtonItem!
    
    var item: Any?
    
    private var menuItem: MenuItem?
    private var menuItemOptions: [StandardOption]?
    private var menuItemExtras: [ExtraOption]?
    private var menuItemPrices: [Price]?
    private var currentPriceIndexPath: NSIndexPath?
    private var article: Article?
    
    private let ADD_TO_FAV = "Add to favorites"
    private let REMOVE_FROM_FAV = "Remove from favorites"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.tableFooterView = UIView()
        if (item is MenuItem) {
            menuItem = item as? MenuItem
            menuItemOptions = menuItem?.standardOptions as? [StandardOption]
            menuItemExtras = menuItem?.extraOptions as? [ExtraOption]
            menuItemPrices = menuItem?.prices as? [Price]
            
            if (UserDefaultsHelper.shared.getFavoriteMenuItems().filter({ $0.objectId == menuItem?.objectId }).first != nil) {
                addToFavoritesButton.title = REMOVE_FROM_FAV
            }
        }
        else if (item is Article) {
            article = item as? Article
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (item is MenuItem) {
            navigationController?.setToolbarHidden(false, animated: true)
        }
        else {
            cartButton.isEnabled = false
            cartButton.tintColor = UIColor.clear
            navigationController?.setToolbarHidden(true, animated: true)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        selectPriceAutomatically()
    }
    
    func selectPriceAutomatically() {
        if (currentPriceIndexPath == nil) {
            currentPriceIndexPath = NSIndexPath.init(row: 0, section: 4)
        }
        table.selectRow(at: currentPriceIndexPath! as IndexPath, animated: false, scrollPosition: UITableViewScrollPosition.none)
        table.delegate?.tableView!(table, didSelectRowAt: currentPriceIndexPath! as IndexPath)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setToolbarHidden(true, animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if (item is MenuItem) {
            return 5
        }
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0 || section == 1) {
            return 1
        }
        else if (section == 2) {
            if (item != nil && item is MenuItem && menuItemOptions != nil) {
                return (menuItemOptions?.count)!
            }
            return 0
        }
        else if (section == 3) {
            if (item != nil && item is MenuItem && menuItemExtras != nil) {
                return (menuItemExtras?.count)!
            }
            return 0
        }
        else if (section == 4) {
            table.allowsSelection = true
            if (item != nil && item is MenuItem && menuItemPrices != nil) {
                return (menuItemPrices?.count)!
            }
            return 0
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 2) {
            return "Options"
        }
        else if (section == 3) {
            return "Extras"
        }
        else if (section == 4) {
            return "Size and prices"
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemImageCell", for: indexPath)
            cell.isUserInteractionEnabled = false
            cell.selectionStyle = .none
            cell.backgroundView = UIImageView.init(image: UIImage.init(named: "waitingImage.png"))
            cell.backgroundView?.contentMode = .scaleAspectFill
            if (item is MenuItem) {
                if let picture = menuItem?.pictures?.firstObject {
                    PictureHelper.shared.setImageFromUrl((picture as! Picture).url!, cell)
                }
            }
            else if (item is Article) {
                PictureHelper.shared.setImageFromUrl((article?.picture?.url)!, cell)
            }
            return cell
        }
        else if (indexPath.section == 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemInfoCell", for: indexPath) as! ItemInfoCell
            cell.isUserInteractionEnabled = false
            cell.selectionStyle = .none
            if (item is MenuItem) {
                cell.titleLabel.text = menuItem?.title
                var tagsString = "• "
                for tag in (menuItem?.tags)! {
                    tagsString.append(String(format:"%@, ", (tag as! Tag).name!))
                }
                if (tagsString.count > 0) {
                    tagsString.removeLast(2)
                }
                cell.tagsLabel.text = tagsString
                cell.bodyLabel.text = menuItem?.body
            }
            else if (item is Article) {
                cell.titleLabel.text = article?.title
                cell.tagsLabel.isHidden = true
                cell.bodyLabel.text = article?.body
            }
            return cell
        }
        else if (indexPath.section == 2) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OptionCell", for: indexPath) as! OptionsAndExtrasCell
            cell.selectionStyle = .none
            cell.menuItem = menuItem
            let option = menuItemOptions![indexPath.row]
            cell.optionLabel.text = option.name
            cell.selectedSwitch.setOn((option.selected?.boolValue)!, animated: true)
            return cell
        }
        else if (indexPath.section == 3) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExtraCell", for: indexPath) as! OptionsAndExtrasCell
            cell.selectionStyle = .none
            cell.menuItem = menuItem
            let extra = menuItemExtras![indexPath.row]
            cell.optionLabel.text = String(format:"%@: $%@", extra.name!, extra.value!)
            cell.selectedSwitch.setOn((extra.selected?.boolValue)!, animated: true)
            return cell
        }
        else if (indexPath.section == 4) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SizeAndPriceCell", for: indexPath) as! SizeAndPriceCell
            cell.selectionStyle = .none
            let price = menuItemPrices![indexPath.row]
            cell.sizeAndPriceLabel.text = String(format:"%@: $%@", price.name!, price.value!)
            return cell;
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 4) {
            let cell = table.cellForRow(at: indexPath)
            cell?.accessoryType = .checkmark
            currentPriceIndexPath = indexPath as NSIndexPath
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if (indexPath.section == 4) {
            let cell = table.cellForRow(at: indexPath) as! SizeAndPriceCell
            cell.accessoryType = .none
        }
    }
    
    @IBAction func pressedAddToCart(_ sender: Any) {
        Types.tryblock({
            let selectedPrice = self.menuItem?.prices![(self.currentPriceIndexPath?.row)!] as! Price
            self.menuItem?.prices = [selectedPrice]
            UserDefaultsHelper.shared.addItemToShoppingCart(self.menuItem!)
            self.menuItem?.prices = (self.item as! MenuItem).prices
            AlertViewController.showAddedToCartAlert("Shopping Cart", "Menu item added to cart", self, { continueShopping in
                self.performSegue(withIdentifier: "unwindToItemsVC", sender: nil)
            }, { goToCart in
                self.addToCartButton.title = "Already added to cart"
                self.addToCartButton.isEnabled = false
                self.table.isUserInteractionEnabled = false
                self.performSegue(withIdentifier: "ShowCart", sender: nil)
            })
            
        }, catchblock: { exception in
            let fault = Fault.fault((exception as! NSException).name.rawValue, detail: (exception as! NSException).reason)
            AlertViewController.showErrorAlert(fault as! Fault, self, nil)
        })
    }
    
    @IBAction func pressedAddToFavorites(_ sender: Any) {
        if (addToFavoritesButton.title == ADD_TO_FAV) {
           addToFavoritesButton.title = REMOVE_FROM_FAV
            UserDefaultsHelper.shared.addItemToFavorites(menuItem!)
        }
        else {
            addToFavoritesButton.title = ADD_TO_FAV
            UserDefaultsHelper.shared.removeItemFromFavorites(menuItem!)
        }
    }
    
    @IBAction func pressedGoToCart(_ sender: Any) {
        self.performSegue(withIdentifier: "ShowCart", sender: nil)
    }
}
