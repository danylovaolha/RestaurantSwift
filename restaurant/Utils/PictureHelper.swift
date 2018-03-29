
import UIKit

class PictureHelper: NSObject {
    static let shared = PictureHelper()
    
    private override init() { }
    
    func setImageFromUrl(_ url: String, _ cell: UITableViewCell) {
        if (UserDefaultsHelper.shared.getImageFromUserDefaults(url) != nil) {
            cell.backgroundView = UIImageView.init(image: UserDefaultsHelper.shared.getImageFromUserDefaults(url))
            cell.backgroundView?.contentMode = .scaleAspectFill
        }
        else {
            DispatchQueue.global(qos: .default).async(execute: {() -> Void in
                if let urlFromString = URL(string: url) {
                    if let data = try? Data(contentsOf: urlFromString) {
                        if let image = UIImage(data: data) {
                            UserDefaultsHelper.shared.saveImageToUserDefaults(image, url)
                            DispatchQueue.main.async(execute: {() -> Void in
                                cell.backgroundView = UIImageView(image: image)
                                cell.backgroundView?.contentMode = .scaleAspectFill
                            })
                        }
                    }
                }
            })
        }
    }
    
    func setSmallImageFromUrl(_ url: String, _ cell: UITableViewCell) {
        if (cell.isKind(of: ItemCell.ofClass())) {
            if (UserDefaultsHelper.shared.getImageFromUserDefaults(url) != nil) {
                (cell as! ItemCell).pictureView.image = UserDefaultsHelper.shared.getImageFromUserDefaults(url)
            }
            else {
                DispatchQueue.global(qos: .default).async(execute: {() -> Void in
                    if let urlFromString = URL(string: url) {
                        if let data = try? Data(contentsOf: urlFromString) {
                            if let image = UIImage(data: data) {
                                UserDefaultsHelper.shared.saveImageToUserDefaults(image, url)
                                DispatchQueue.main.async(execute: {() -> Void in
                                    (cell as! ItemCell).pictureView.image = image
                                })
                            }
                        }
                    }
                })
            }
        }
        
        else if (cell.isKind(of: ShoppingCartCell.ofClass())) {
            if (UserDefaultsHelper.shared.getImageFromUserDefaults(url) != nil) {
                (cell as! ShoppingCartCell).pictureView.image = UserDefaultsHelper.shared.getImageFromUserDefaults(url)
            }
            else {
                DispatchQueue.global(qos: .default).async(execute: {() -> Void in
                    if let urlFromString = URL(string: url) {
                        if let data = try? Data(contentsOf: urlFromString) {
                            if let image = UIImage(data: data) {
                                UserDefaultsHelper.shared.saveImageToUserDefaults(image, url)
                                DispatchQueue.main.async(execute: {() -> Void in
                                    (cell as! ShoppingCartCell).pictureView.image = image
                                })
                            }
                        }
                    }
                })
            }
        }
    }    
}
