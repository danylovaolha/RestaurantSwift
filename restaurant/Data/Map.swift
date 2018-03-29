
import UIKit

@objcMembers
class Map: NSObject {
    var created : Date?
    var updated : Date?
    var zoomLevel : NSNumber?
    var ownerId : String?
    var objectId : String?    
    var origin : GeoPoint?
    var annotations : NSMutableArray?
}
            
