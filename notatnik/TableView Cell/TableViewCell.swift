
import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var data: UILabel!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var miniView: UIVisualEffectView!
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        miniView.layer.cornerRadius = 20
        miniView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
