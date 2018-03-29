
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
        }
        
        /*
         self.table.tableFooterView = [UIView new];
         if ([self.item isKindOfClass:[MenuItem class]]) {
         menuItem = self.item;
         menuItemOptions = menuItem.standardOptions;
         menuItemExtras = menuItem.extraOptions;
         menuItemPrices = menuItem.prices;
         NSPredicate *predicate = [NSPredicate predicateWithFormat:@"objectId == %@", menuItem.objectId];
         if ([[userDefaultsHelper getFavoriteMenuItems] filteredArrayUsingPredicate:predicate].firstObject) {
         self.addToFavoritesButton.title = REMOVE_FROM_FAV;
         }
         }
         else if ([self.item isKindOfClass:[Article class]]) {
         article = self.item;
         }
         */
    }
    
    @IBAction func pressedAddToCart(_ sender: Any) {
    }
    
    @IBAction func pressedAddToFavorites(_ sender: Any) {
    }
    
    @IBAction func pressedGoToCart(_ sender: Any) {
    }
}
