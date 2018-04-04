
import UIKit

@objcMembers
class Tag: NSObject, NSCoding {
    var updated : Date?
    var created : Date?
    var ownerId : String?
    var name : String?
    var objectId : String?
    
    override init() { }
    
    required init?(coder aDecoder: NSCoder) {
        self.updated = aDecoder.decodeObject(forKey: "updated") as? Date
        self.created = aDecoder.decodeObject(forKey: "created") as? Date
        self.ownerId = aDecoder.decodeObject(forKey: "ownerId") as? String
        self.name = aDecoder.decodeObject(forKey: "name") as? String
        self.objectId = aDecoder.decodeObject(forKey: "objectId") as? String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.updated, forKey: "updated")
        aCoder.encode(self.created, forKey: "created")
        aCoder.encode(self.ownerId, forKey: "ownerId")
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.objectId, forKey: "objectId")
    }
}
            
