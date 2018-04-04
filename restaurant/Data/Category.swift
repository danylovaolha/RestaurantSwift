
import UIKit

@objcMembers
class Category: NSObject, NSCoding {
    var icon : String?
    var updated : Date?
    var objectId : String?
    var featured : NSNumber?
    var title : String?
    var desc : String?
    var created : Date?
    var ownerId : String?
    var thumb : Picture?

    override init() { }
    
    required init?(coder aDecoder: NSCoder) {
        self.icon = aDecoder.decodeObject(forKey: "icon") as? String
        self.updated = aDecoder.decodeObject(forKey: "updated") as? Date
        self.objectId = aDecoder.decodeObject(forKey: "objectId") as? String
        self.featured = aDecoder.decodeObject(forKey: "featured") as? NSNumber
        self.title = aDecoder.decodeObject(forKey: "title") as? String
        self.desc = aDecoder.decodeObject(forKey: "desc") as? String
        self.created = aDecoder.decodeObject(forKey: "created") as? Date
        self.ownerId = aDecoder.decodeObject(forKey: "ownerId") as? String
        self.thumb = aDecoder.decodeObject(forKey: "thumb") as? Picture
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.icon, forKey: "icon")
        aCoder.encode(self.updated, forKey: "updated")
        aCoder.encode(self.objectId, forKey: "objectId")
        aCoder.encode(self.featured, forKey: "featured")
        aCoder.encode(self.title, forKey: "title")
        aCoder.encode(self.desc, forKey: "desc")
        aCoder.encode(self.created, forKey: "created")
        aCoder.encode(self.ownerId, forKey: "ownerId")
        aCoder.encode(self.thumb, forKey: "thumb")        
    }
}
            
