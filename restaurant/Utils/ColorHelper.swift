
import UIKit

final class ColorHelper: NSObject {
    static let shared = ColorHelper()
    
    private override init() { }
    
    func getColorFromHex(_ hexColor: String, _ alpha:CGFloat) -> UIColor {
        var rgbValue: UInt64 = 0
        let scanner = Scanner.init(string: hexColor)
        scanner.scanLocation = 1 // bypass '#' character
        scanner.scanHexInt64(&rgbValue)
        
        return UIColor(red: CGFloat((((rgbValue & 0xff) >> 16) / 0xff)), green: CGFloat((((rgbValue & 0xff) >> 8) / 0xff)), blue: CGFloat(((rgbValue & 0xff) / 0xff)), alpha: alpha)
    }
}
