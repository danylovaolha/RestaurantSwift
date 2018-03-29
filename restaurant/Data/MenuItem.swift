
import UIKit

@objcMembers
class MenuItem: NSObject {
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
}
            
