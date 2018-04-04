
import UIKit

@objcMembers
class MenuItem: NSObject, NSCoding {
    var updated : Date?
    var created : Date?
    var body : String?
    var isFeatured : NSNumber?
    var title : String?
    var objectId : String?
    var ownerId : String?
    var category : Category?
    var extraOptions : NSMutableArray?
    var tags : NSMutableArray?
    var prices : NSMutableArray?
    var pictures : NSMutableArray?
    var thumb : Picture?                            
    var standardOptions : NSMutableArray?
    
    override init() { }
    
    required init?(coder aDecoder: NSCoder) {
        self.updated = aDecoder.decodeObject(forKey: "updated") as? Date
        self.created = aDecoder.decodeObject(forKey: "created") as? Date
        self.body = aDecoder.decodeObject(forKey: "body") as? String
        self.isFeatured = aDecoder.decodeObject(forKey: "isFeatured") as? NSNumber
        self.title = aDecoder.decodeObject(forKey: "title") as? String
        self.objectId = aDecoder.decodeObject(forKey: "objectId") as? String
        self.ownerId = aDecoder.decodeObject(forKey: "ownerId") as? String
        self.category = aDecoder.decodeObject(forKey: "category") as? Category
        self.extraOptions = aDecoder.decodeObject(forKey: "extraOptions") as? NSMutableArray
        self.tags = aDecoder.decodeObject(forKey: "tags") as? NSMutableArray
        self.prices = aDecoder.decodeObject(forKey: "prices") as? NSMutableArray
        self.pictures = aDecoder.decodeObject(forKey: "pictures") as? NSMutableArray
        self.thumb = aDecoder.decodeObject(forKey: "thumb") as? Picture
        self.standardOptions = aDecoder.decodeObject(forKey: "standardOptions") as? NSMutableArray
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.updated, forKey: "updated")
        aCoder.encode(self.created, forKey: "created")
        aCoder.encode(self.body, forKey: "body")
        aCoder.encode(self.isFeatured, forKey: "isFeatured")
        aCoder.encode(self.title, forKey: "title")
        aCoder.encode(self.objectId, forKey: "objectId")
        aCoder.encode(self.ownerId, forKey: "ownerId")
        aCoder.encode(self.category, forKey: "category")
        aCoder.encode(self.extraOptions, forKey: "extraOptions")
        aCoder.encode(self.tags, forKey: "tags")
        aCoder.encode(self.prices, forKey: "prices")
        aCoder.encode(self.pictures, forKey: "pictures")
        aCoder.encode(self.thumb, forKey: "thumb")
        aCoder.encode(self.standardOptions, forKey: "standardOptions")
    }
}
            
