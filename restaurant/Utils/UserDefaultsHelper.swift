
import UIKit

final class UserDefaultsHelper: NSObject {
    static let shared = UserDefaultsHelper()
    
    private let FAVORITES_KEY = "restaurantFavorites"
    private let SHOPPING_CART_KEY = "restaurantShoppingCart"
    private let IMAGES_KEY = "restaurantImages"
    
    private override init() { }
    
    func addItemToFavorites(_ menuItem: MenuItem) {
        var favoriteItems = [MenuItem]()
        if let data = UserDefaults.standard.object(forKey: FAVORITES_KEY) {
            favoriteItems = NSKeyedUnarchiver.unarchiveObject(with: data as! Data) as! [MenuItem]
        }
        favoriteItems.append(menuItem)
        let data = NSKeyedArchiver.archivedData(withRootObject: favoriteItems)
        UserDefaults.standard.set(data, forKey: FAVORITES_KEY)
        UserDefaults.standard.synchronize()
    }
    
    func removeItemFromFavorites(_ menuItem: MenuItem) {
        if var data = UserDefaults.standard.object(forKey: FAVORITES_KEY) as? Data {
            var favoriteItems = NSKeyedUnarchiver.unarchiveObject(with: data) as? [MenuItem]
            if let menuItemToRemove = favoriteItems?.filter({ $0.objectId == menuItem.objectId }).first {
                let index = favoriteItems?.index(of: menuItemToRemove)
                favoriteItems?.remove(at: index!)
            }
            data = NSKeyedArchiver.archivedData(withRootObject: favoriteItems as Any)
            UserDefaults.standard.set(data, forKey: FAVORITES_KEY)
            UserDefaults.standard.synchronize()
        }
    }
    
    func getFavoriteMenuItems() -> [MenuItem] {
        if let data = UserDefaults.standard.object(forKey: FAVORITES_KEY) as? Data {
            if let favoriteItems = NSKeyedUnarchiver.unarchiveObject(with: data) as? [MenuItem] {
                return favoriteItems;
            }
        }
        return [MenuItem]()
    }
    
    func addItemToShoppingCart(_ menuItem: MenuItem) {
        let shoppingCartItem = ShoppingCartItem()
        shoppingCartItem.menuItem = menuItem
        shoppingCartItem.quantity = 1
        
        let menuItemPrice = menuItem.prices?.firstObject as? Price
        let price = menuItemPrice?.value
        let extraOptions = menuItem.extraOptions
        
        var extraPrice = 0.0;
        
        for extra in extraOptions! {
            if ((extra as! ExtraOption).selected == 1) {
                extraPrice = extraPrice + ((extra as! ExtraOption).value?.doubleValue)!
            }
        }
        shoppingCartItem.price = ((price?.doubleValue)! + extraPrice) as NSNumber
        ShoppingCart.shared.totalPrice = NSNumber(value:((ShoppingCart.shared.totalPrice?.doubleValue)! + (shoppingCartItem.price?.doubleValue)!))
        
        var shoppingCartItems = [ShoppingCartItem]()
        if let data = UserDefaults.standard.object(forKey: SHOPPING_CART_KEY) as? Data {
            shoppingCartItems = NSKeyedUnarchiver.unarchiveObject(with: data) as! [ShoppingCartItem]
        }
        
        var preventAdd = false
        if (shoppingCartItems.count > 0) {
            preventAdd = true
            for item in shoppingCartItems {
                preventAdd = preventFromAdd(menuItem, item)
                if (preventAdd) {
                    break
                }
            }
        }
        if (!preventAdd) {
            shoppingCartItems.append(shoppingCartItem)
            let data = NSKeyedArchiver.archivedData(withRootObject: shoppingCartItems as Any)
            UserDefaults.standard.set(data, forKey: SHOPPING_CART_KEY)
            UserDefaults.standard.synchronize()
        }
    }
    
    func preventFromAdd(_ menuItem: MenuItem, _ shoppingCartItem: ShoppingCartItem) -> Bool {
        var prevent = true
        // if prices are not equal - add to cart
        let menuItemBasicPrice = ((menuItem.prices?.firstObject) as! Price).value
        let shoppingCartItemBasicPrice = ((shoppingCartItem.menuItem?.prices?.firstObject) as! Price).value
        if (menuItemBasicPrice != shoppingCartItemBasicPrice) {
            prevent = false
            return prevent
        }
        else {
            // if prices are equal - check standard options
            let menuItemStandardOptions = menuItem.standardOptions
            let shoppingCartItemStandardOptions = shoppingCartItem.menuItem?.standardOptions
            if ((menuItemStandardOptions?.count == 0 && (shoppingCartItemStandardOptions?.count)! > 0) ||
                ((menuItemStandardOptions?.count)! > 0 && shoppingCartItemStandardOptions?.count == 0)) {
                prevent = false
                return prevent
            }
            else {
                // comparing standard options
                for menuItemStandardOption in menuItemStandardOptions! {
                    let p1 = NSPredicate.init(format: "selected = %@", (menuItemStandardOption as! StandardOption).selected!)
                    let p2 = NSPredicate.init(format: "name = %@", (menuItemStandardOption as! StandardOption).name!)
                    let predicate = NSCompoundPredicate.init(andPredicateWithSubpredicates: [p1, p2])
                    let existingItems = shoppingCartItemStandardOptions?.filtered(using: predicate)
                    if (existingItems?.count == 0) {
                        prevent = false
                        return prevent
                    }
                }
                // if standard options are equal - check extra options
                let menuItemExtraOptions = menuItem.extraOptions
                let shoppingCartItemExtraOptions = shoppingCartItem.menuItem?.extraOptions
                
                if ((menuItemExtraOptions?.count == 0 && (shoppingCartItemExtraOptions?.count)! > 0) ||
                    ((menuItemExtraOptions?.count)! > 0 && shoppingCartItemExtraOptions?.count == 0)) {
                    prevent = false
                    return prevent
                }
                else {
                    // comparing extra options
                    for menuItemExtraOption in menuItemExtraOptions! {
                        let p1 = NSPredicate.init(format: "selected = %@", (menuItemExtraOption as! ExtraOption).selected!)
                        let p2 = NSPredicate.init(format: "name = %@", (menuItemExtraOption as! ExtraOption).name!)
                        let p3 = NSPredicate.init(format: "value = %@", (menuItemExtraOption as! ExtraOption).value!)
                        let predicate = NSCompoundPredicate.init(andPredicateWithSubpredicates: [p1, p2, p3])
                        let existingItems = shoppingCartItemExtraOptions?.filtered(using: predicate)
                        if (existingItems?.count == 0) {
                            prevent = false
                            return prevent
                        }
                    }
                }
            }
        }
        return prevent
    }
    
    func removeItemFromShoppingCart(_ menuItem: MenuItem) {
        if var data = UserDefaults.standard.object(forKey: SHOPPING_CART_KEY) as? Data {
            var shoppingCartItems = NSKeyedUnarchiver.unarchiveObject(with: data) as? [ShoppingCartItem]
            var preventDelete = true
            var itemToDelete: ShoppingCartItem?
            for item in shoppingCartItems! {
                preventDelete = preventFromDelete(menuItem, item)
                if (!preventDelete) {
                    itemToDelete = item
                    break
                }
            }
            if (itemToDelete != nil) {
                let index = shoppingCartItems?.index(of: itemToDelete!)
                shoppingCartItems?.remove(at: index!)
                data = NSKeyedArchiver.archivedData(withRootObject: shoppingCartItems as Any)
                UserDefaults.standard.set(data, forKey: SHOPPING_CART_KEY)
                UserDefaults.standard.synchronize()
            }
        }
    }
    
    func preventFromDelete(_ menuItem: MenuItem, _ shoppingCartItem: ShoppingCartItem) -> Bool {
        var prevent = true
        let checkExtraOptions: (() -> (Bool))? = {
            // check extra options
            let menuItemExtraOptions = menuItem.extraOptions
            let shoppingCartItemExtraOptions = shoppingCartItem.menuItem?.extraOptions
            if (menuItemExtraOptions?.count == shoppingCartItemExtraOptions?.count) {
                if ((menuItemExtraOptions?.count)! > 0) {
                    // compare extra options
                    for menuItemExtraOption in menuItemExtraOptions! {
                        let p1 = NSPredicate.init(format: "selected = %@", (menuItemExtraOption as! ExtraOption).selected!)
                        let p2 = NSPredicate.init(format: "name = %@", (menuItemExtraOption as! ExtraOption).name!)
                        let p3 = NSPredicate.init(format: "value = %@", (menuItemExtraOption as! ExtraOption).value!)
                        let predicate = NSCompoundPredicate.init(andPredicateWithSubpredicates: [p1, p2, p3])
                        let existingItems = shoppingCartItemExtraOptions?.filtered(using: predicate)
                        if ((existingItems?.count)! > 0) {
                            prevent = false
                            return prevent
                        }
                    }
                }
                else {
                    prevent = false
                    return prevent
                }
            }
            return prevent
        }
        // if prices are not equal - prevent = YES;
        let menuItemBasicPrice = (menuItem.prices?.firstObject as! Price).value
        let shoppingCartItemBasicPrice = (shoppingCartItem.menuItem?.prices?.firstObject as! Price).value
        if (menuItemBasicPrice == shoppingCartItemBasicPrice) {
            // check standard options
            let menuItemStandardOptions = menuItem.standardOptions
            let shoppingCartItemStandardOptions = shoppingCartItem.menuItem?.standardOptions
            if (menuItemStandardOptions?.count == shoppingCartItemStandardOptions?.count) {
                if ((menuItemStandardOptions?.count)! > 0) {
                    // compare standard options
                    for menuItemStandardOption in menuItemStandardOptions! {
                        let p1 = NSPredicate.init(format: "selected = %@", (menuItemStandardOption as! StandardOption).selected!)
                        let p2 = NSPredicate.init(format: "name = %@", (menuItemStandardOption as! StandardOption).name!)
                        let predicate = NSCompoundPredicate.init(andPredicateWithSubpredicates: [p1, p2])
                        let existingItems = shoppingCartItemStandardOptions?.filtered(using: predicate)
                        if ((existingItems?.count)! > 0) {
                            prevent = checkExtraOptions!()
                            return prevent
                        }
                    }
                }
                else {
                    prevent = checkExtraOptions!()
                    return prevent
                }
            }
        }
        return prevent
    }
    
    func removeAllItemsFromShoppingCart() {
        if var data = UserDefaults.standard.object(forKey: SHOPPING_CART_KEY) as? Data {
            var shoppingCartItems = NSKeyedUnarchiver.unarchiveObject(with: data) as? [ShoppingCartItem]
            shoppingCartItems?.removeAll()
            data = NSKeyedArchiver.archivedData(withRootObject: shoppingCartItems as Any)
            UserDefaults.standard.set(data, forKey: SHOPPING_CART_KEY)
            UserDefaults.standard.synchronize()
        }
    }
    
    func getShoppingCartItems() -> [ShoppingCartItem] {
        if let data = UserDefaults.standard.object(forKey: SHOPPING_CART_KEY) as? Data {
            if let shoppingCartItems = NSKeyedUnarchiver.unarchiveObject(with: data) {
                return shoppingCartItems as! [ShoppingCartItem]
            }
        }
        return [ShoppingCartItem]()
    }
    
    func saveShoppingCartItem(_ shoppingCartItem: ShoppingCartItem, _ index: Int) {
        let shoppingCartItems = self.getShoppingCartItems()
        let cartItem = shoppingCartItems[index]
        cartItem.quantity = shoppingCartItem.quantity
        let data = NSKeyedArchiver.archivedData(withRootObject: shoppingCartItems as Any)
        UserDefaults.standard.set(data, forKey: SHOPPING_CART_KEY)
        UserDefaults.standard.synchronize()
    }
    
    func saveImageToUserDefaults(_ image: UIImage?, _ key: String) {
        if (image != nil) {
            var images = [String : Any]()
            if let data = UserDefaults.standard.object(forKey: IMAGES_KEY) as? Data {
                images = NSKeyedUnarchiver.unarchiveObject(with: data) as! [String : Any]
            }
            else {
                images = [String : UIImage]()
            }
            if (images[key] == nil) {
                images[key] = image;
            }
            let data = NSKeyedArchiver.archivedData(withRootObject: images as Any)
            UserDefaults.standard.set(data, forKey: IMAGES_KEY)
            UserDefaults.standard.synchronize()
        }
    }
    
    func getImageFromUserDefaults(_ key: String) -> UIImage? {
        if let data = UserDefaults.standard.object(forKey: IMAGES_KEY) as? Data {
            if let images = NSKeyedUnarchiver.unarchiveObject(with: data) as? [String : UIImage] {
                if (images[key] != nil) {
                    return images[key]!
                }
            }
        }
        return nil
    }
}
