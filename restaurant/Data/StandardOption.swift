
import UIKit

@objcMembers
class StandardOption: NSObject, NSCoding {
    var objectId : String?
    var selected : NSNumber?
    var ownerId : String?
    var name : String?
    var created : Date?
    var updated : Date?
    
    override init() { }
    
    required init?(coder aDecoder: NSCoder) {
        self.objectId = aDecoder.decodeObject(forKey: "objectId") as? String
        self.selected = aDecoder.decodeObject(forKey: "selected") as? NSNumber
        self.ownerId = aDecoder.decodeObject(forKey: "ownerId") as? String
        self.name = aDecoder.decodeObject(forKey: "name") as? String
        self.created = aDecoder.decodeObject(forKey: "created") as? Date
        self.updated = aDecoder.decodeObject(forKey: "updated") as? Date
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.objectId, forKey: "objectId")
        aCoder.encode(self.selected, forKey: "selected")
        aCoder.encode(self.ownerId, forKey: "ownerId")
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.created, forKey: "created")
        aCoder.encode(self.updated, forKey: "updated")
    }
}
            
