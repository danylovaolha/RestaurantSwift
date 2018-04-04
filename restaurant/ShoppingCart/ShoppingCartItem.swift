
import UIKit

class ShoppingCartItem: NSObject, NSCoding {
    var menuItem: MenuItem?
    var quantity: NSNumber?
    var price: NSNumber?
    
    override init() { }
    
    required init?(coder aDecoder: NSCoder) {
        self.menuItem = aDecoder.decodeObject(forKey: "menuItem") as? MenuItem
        self.quantity = aDecoder.decodeObject(forKey: "quantity") as? NSNumber
        self.price = aDecoder.decodeObject(forKey: "price") as? NSNumber
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.menuItem, forKey: "menuItem")
        aCoder.encode(self.quantity, forKey: "quantity")
        aCoder.encode(self.price, forKey: "price")
    }
}
