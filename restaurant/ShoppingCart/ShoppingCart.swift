
import UIKit

final class ShoppingCart: NSObject {
    static let shared = ShoppingCart()
    
    var shoppingCartItems: [ShoppingCartItem]?
    var totalPrice: NSNumber?
    
    private override init() { }
    
    func clearCart() {
        UserDefaultsHelper.shared.removeAllItemsFromShoppingCart()
    }
}
