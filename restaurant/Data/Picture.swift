
import UIKit

@objcMembers
class Picture: NSObject, NSCoding {
    var url : String?
    var ownerId : String?
    var created : Date?
    var updated : Date?
    var objectId : String?
    
    override init() { }
    
    required init?(coder aDecoder: NSCoder) {
        self.url = aDecoder.decodeObject(forKey: "url") as? String
        self.ownerId = aDecoder.decodeObject(forKey: "ownerId") as? String
        self.created = aDecoder.decodeObject(forKey: "created") as? Date
        self.updated = aDecoder.decodeObject(forKey: "updated") as? Date
        self.objectId = aDecoder.decodeObject(forKey: "objectId") as? String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.url, forKey: "url")
        aCoder.encode(self.ownerId, forKey: "ownerId")
        aCoder.encode(self.created, forKey: "created")
        aCoder.encode(self.updated, forKey: "updated")
        aCoder.encode(self.objectId, forKey: "objectId")
    }
}
            
