
import UIKit

final class UserDefaultsHelper: NSObject {
    static let shared = UserDefaultsHelper()
    
    private let FAVORITES_KEY = "restaurantFavorites"
    private let SHOPPING_CART_KEY = "restaurantShoppingCart"
    private let IMAGES_KEY = "restaurantImages"
    private let shoppingCart = ShoppingCart.shared
    
    private override init() { }
    
    func addItemToFavorites(_ menuItem: MenuItem) {
        if var data = UserDefaults.standard.object(forKey: FAVORITES_KEY) as? Data {
            var favoriteItems = NSKeyedUnarchiver.unarchiveObject(with: data) as? [MenuItem]
            if (favoriteItems == nil) {
                favoriteItems = [MenuItem]()
            }
            favoriteItems?.append(menuItem)
            data = NSKeyedArchiver.archivedData(withRootObject: favoriteItems as Any)
            UserDefaults.standard.set(data, forKey: FAVORITES_KEY)
            UserDefaults.standard.synchronize()
        }
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
        shoppingCart.totalPrice = (shoppingCart.totalPrice?.doubleValue)! + (shoppingCartItem.price?.doubleValue)! as NSNumber
        if var data = UserDefaults.standard.object(forKey: SHOPPING_CART_KEY) as? Data {
            var shoppingCartItems = NSKeyedUnarchiver.unarchiveObject(with: data) as? [ShoppingCartItem]
            if (shoppingCartItems == nil) {
                shoppingCartItems = [ShoppingCartItem]()
            }
            
            var preventAdd = true
            if ((shoppingCartItems?.count)! > 0) {
                for item in shoppingCartItems! {
                    preventAdd = preventFromAdd(menuItem, item)
                    if (preventAdd) {
                        break
                    }
                }
            }
            if (shoppingCartItems?.count == 0 || !preventAdd) {
                shoppingCartItems?.append(shoppingCartItem)
                data = NSKeyedArchiver.archivedData(withRootObject: shoppingCartItems as Any)
                UserDefaults.standard.set(data, forKey: SHOPPING_CART_KEY)
                UserDefaults.standard.synchronize()
            }
        }
    }
    
    func preventFromAdd(_ menuItem: MenuItem, _ shoppingCartItem: ShoppingCartItem) -> Bool {
        var prevent = true
        
        // если цены не совпадают - добавляем в корзину
        
        let menuItemBasicPrice = ((menuItem.prices?.firstObject) as! Price).value
        let shoppingCartItemBasicPrice = ((shoppingCartItem.menuItem?.prices?.firstObject) as! Price).value
        
        if (menuItemBasicPrice != shoppingCartItemBasicPrice) {
            prevent = false
            return prevent
        }
        else {
            // если цены совпадают - проверяем стандартные опции
            
            let menuItemStandardOptions = menuItem.standardOptions
            let shoppingCartItemStandardOptions = shoppingCartItem.menuItem?.standardOptions
            
            if ((menuItemStandardOptions?.count == 0 && (shoppingCartItemStandardOptions?.count)! > 0) ||
                ((menuItemStandardOptions?.count)! > 0 && shoppingCartItemStandardOptions?.count == 0)) {
                prevent = false
                return prevent
            }
            else {
                // проверяем стандартные опции на совпадение
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
                
                // если стандартные опции совпадают - проверяем нестандартные опции
                let menuItemExtraOptions = menuItem.extraOptions
                let shoppingCartItemExtraOptions = shoppingCartItem.menuItem?.extraOptions
                
                if ((menuItemExtraOptions?.count == 0 && (shoppingCartItemExtraOptions?.count)! > 0) ||
                    ((menuItemExtraOptions?.count)! > 0 && shoppingCartItemExtraOptions?.count == 0)) {
                    prevent = false
                    return prevent
                }
                else {
                    // проверяем нестандартные опции на совпадение
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
            // проверяем нестандартные опции
            let menuItemExtraOptions = menuItem.extraOptions
            let shoppingCartItemExtraOptions = shoppingCartItem.menuItem?.extraOptions
            
            if (menuItemExtraOptions?.count == shoppingCartItemExtraOptions?.count) {
                if ((menuItemExtraOptions?.count)! > 0) {
                    // проверяем нестандартные опции на совпадение
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
                else {
                    prevent = false
                    return prevent
                }
            }
            return prevent
        }
        
        // если цены не совпадают - сразу не катит
        let menuItemBasicPrice = (menuItem.prices?.firstObject as! Price).value
        let shoppingCartItemBasicPrice = (shoppingCartItem.menuItem?.prices?.firstObject as! Price).value
        
        if (menuItemBasicPrice == shoppingCartItemBasicPrice) {
            // проверяем стандартные опции
            
            let menuItemStandardOptions = menuItem.standardOptions
            let shoppingCartItemStandardOptions = shoppingCartItem.menuItem?.standardOptions
            
            if (menuItemStandardOptions?.count == shoppingCartItemStandardOptions?.count) {
                if ((menuItemStandardOptions?.count)! > 0) {
                    // проверяем стандартные опции на совпадение
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
            UserDefaults.standard.set(data, forKey: FAVORITES_KEY)
            UserDefaults.standard.synchronize()
        }
    }
    
    func getShoppingCartItems() -> [ShoppingCartItem] {
        if let data = UserDefaults.standard.object(forKey: SHOPPING_CART_KEY) as? Data {
            if let shoppingCartItems = NSKeyedUnarchiver.unarchiveObject(with: data) as? [ShoppingCartItem] {
                return shoppingCartItems
            }
        }
        return [ShoppingCartItem]()
    }
    
    func saveShoppingCartItem(_ shoppingCartItem: ShoppingCartItem, _ index: Int) {
        let shoppingCartItems = self.getShoppingCartItems()
        // ищем в shoppingCartItems нужный объект (по индексу)
        let cartItem = shoppingCartItems[index]
        cartItem.quantity = shoppingCartItem.quantity
        let data = NSKeyedArchiver.archivedData(withRootObject: shoppingCartItems as Any)
        UserDefaults.standard.set(data, forKey: FAVORITES_KEY)
        UserDefaults.standard.synchronize()
    }
    
    func saveImageToUserDefaults(_ image: UIImage, _ key: String) {
        if var data = UserDefaults.standard.object(forKey: IMAGES_KEY) as? Data {
            var images = NSKeyedUnarchiver.unarchiveObject(with: data) as? [String : UIImage]
            if (images == nil) {
                images = [String : UIImage]()
            }
            if (images![key] == nil) {
                images![key] = image;
            }
            data = NSKeyedArchiver.archivedData(withRootObject: images as Any)
            UserDefaults.standard.set(data, forKey: IMAGES_KEY)
            UserDefaults.standard.synchronize()
        }
    }
    
    func getImageFromUserDefaults(_ key: String) -> UIImage? {
        if let data = UserDefaults.standard.object(forKey: IMAGES_KEY) as? Data {
            if let images = NSKeyedUnarchiver.unarchiveObject(with: data) as? [String : UIImage] {
                return images[key]!
            }
        }
        return nil
    }
}
