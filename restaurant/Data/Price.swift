
import UIKit

@objcMembers
class Price: NSObject, NSCoding {
    var ownerId : String?
    var updated : Date?
    var objectId : String?
    var value : NSNumber?
    var created : Date?
    var currency : String?
    var name : String?
    
    override init() { }
    
    required init?(coder aDecoder: NSCoder) {
        self.ownerId = aDecoder.decodeObject(forKey: "ownerId") as? String
        self.updated = aDecoder.decodeObject(forKey: "updated") as? Date
        self.objectId = aDecoder.decodeObject(forKey: "objectId") as? String
        self.value = aDecoder.decodeObject(forKey: "value") as? NSNumber
        self.created = aDecoder.decodeObject(forKey: "created") as? Date
        self.currency = aDecoder.decodeObject(forKey: "currency") as? String
        self.name = aDecoder.decodeObject(forKey: "name") as? String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.ownerId, forKey: "ownerId")
        aCoder.encode(self.updated, forKey: "updated")
        aCoder.encode(self.objectId, forKey: "objectId")
        aCoder.encode(self.value, forKey: "value")
        aCoder.encode(self.created, forKey: "created")
        aCoder.encode(self.currency, forKey: "currency")
        aCoder.encode(self.name, forKey: "name")
    }
}
            
