
import UIKit

class OptionsAndExtrasCell: UITableViewCell {

    @IBOutlet weak var optionLabel: UILabel!
    @IBOutlet weak var selectedSwitch: UISwitch!
    
    var menuItem: MenuItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        var layoutMargins: UIEdgeInsets {
            get { return UIEdgeInsets.zero }
        }
    }
    
    @IBAction func selectedSwitchAction(_ sender: Any) {
        let indexPath = (self.superview as! UITableView).indexPath(for: self)
        if (indexPath?.section == 2) {
            let predicate = NSPredicate(format: "name == %@", optionLabel.text!)
            let standardOption = menuItem?.standardOptions?.filtered(using: predicate).first as! StandardOption
            if (selectedSwitch.isOn) {
                standardOption.selected = 1
            }
            else {
                standardOption.selected = 0
            }
        }
        else if (indexPath?.section == 3) {
            let range = optionLabel.text?.range(of: ":")
            if let endIndex = range?.lowerBound {
                let predicateString = optionLabel.text![..<endIndex]
                let predicate = NSPredicate(format: "name == %@", String(predicateString))
                let extraOption = menuItem?.extraOptions?.filtered(using: predicate).first as! ExtraOption
                if (selectedSwitch.isOn) {
                    extraOption.selected = 1
                }
                else {
                    extraOption.selected = 0
                }                
            }
        }
    }
}
