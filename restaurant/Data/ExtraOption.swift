
import UIKit

@objcMembers
class ExtraOption: NSObject, NSCoding {
    var created : Date?
    var name : String?
    var selected : NSNumber?
    var value : NSNumber?
    var ownerId : String?
    var updated : Date?
    var objectId : String?
    
    override init() { }
    
    required init?(coder aDecoder: NSCoder) {
        self.created = aDecoder.decodeObject(forKey: "created") as? Date
        self.name = aDecoder.decodeObject(forKey: "name") as? String
        self.selected = aDecoder.decodeObject(forKey: "selected") as? NSNumber
        self.value = aDecoder.decodeObject(forKey: "value") as? NSNumber
        self.ownerId = aDecoder.decodeObject(forKey: "ownerId") as? String
        self.updated = aDecoder.decodeObject(forKey: "updated") as? Date
        self.objectId = aDecoder.decodeObject(forKey: "objectId") as? String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.created, forKey: "created")
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.selected, forKey: "selected")
        aCoder.encode(self.value, forKey: "value")
        aCoder.encode(self.ownerId, forKey: "ownerId")
        aCoder.encode(self.updated, forKey: "updated")
        aCoder.encode(self.objectId, forKey: "objectId")
    }
}
            
