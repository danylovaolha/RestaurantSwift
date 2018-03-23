
import UIKit

final class ColorHelper: NSObject {
    static let shared = ColorHelper()
    
    private override init() { }
    
    func getColorFromHex(_ hexColor: String, _ alpha:CGFloat) -> UIColor {
        var rgbValue: UInt32 = 0
        let scanner = Scanner.init(string: hexColor)
        scanner.scanLocation = 1 // bypass '#' character
        scanner.scanHexInt32(&rgbValue)
        return UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0, green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0, blue: CGFloat(rgbValue & 0x0000FF) / 255.0, alpha: alpha)
    }
}
