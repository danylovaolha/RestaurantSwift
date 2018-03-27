
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
                
            }
        }
    }    
}
 
/*-(void)setSmallImagefFromUrl:(NSString *)url forCell:(UITableViewCell *)cell {
 if ([cell isKindOfClass:[ItemCell class]]) {
 if ([userDefaultsHelper getImageFromUserDefaults:url]) {
 ((ItemCell *)cell).pictureView.image = [userDefaultsHelper getImageFromUserDefaults:url];
 }
 else {
 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
 UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
 [userDefaultsHelper saveImageToUserDefaults:image withKey:url];
 dispatch_async(dispatch_get_main_queue(), ^{
 ((ItemCell *)cell).pictureView.image = image;
 });
 });
 }
 }
 else if ([cell isKindOfClass:[ShoppingCartCell class]]) {
 if ([userDefaultsHelper getImageFromUserDefaults:url]) {
 ((ShoppingCartCell *)cell).pictureView.image = [userDefaultsHelper getImageFromUserDefaults:url];
 }
 else {
 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
 UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
 [userDefaultsHelper saveImageToUserDefaults:image withKey:url];
 dispatch_async(dispatch_get_main_queue(), ^{
 ((ShoppingCartCell *)cell).pictureView.image = image;
 });
 });
 }
 }
 }*/
