//

import UIKit

class NetworkExampleTableViewCell: UITableViewCell {

    public static var cellId = "NetworkExampleTableViewCell"
    public static var bundle: Bundle { return Bundle(for: self) }
    public static var nib: UINib { return UINib(nibName: cellId, bundle: bundle) }

    @IBOutlet var idLabel: UILabel!
    @IBOutlet var userIdLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var bodyLabel: UILabel!
    
    private var presenter: NetworkExampleTableCellPresenter!
    
    override func prepareForReuse() {
        idLabel.text     = ""
        userIdLabel.text = ""
        titleLabel.text  = ""
        bodyLabel.text   = ""
    }
    
    public static func register(with tableView: UITableView) {
        tableView.register(nib, forCellReuseIdentifier: cellId)
    }
    
    public static func loadFromNib(owner: Any?) -> NetworkExampleTableViewCell {
        return bundle.loadNibNamed(cellId, owner: owner, options: nil)?.first as! NetworkExampleTableViewCell
    }
    
    public static func loadFromNib(owner: Any?, presenter: NetworkExampleTableCellPresenter) -> NetworkExampleTableViewCell {
        let cell = NetworkExampleTableViewCell.loadFromNib(owner: owner)
            cell.configure(with: presenter)
        return cell
    }
    
    public func configure(with presenter: NetworkExampleTableCellPresenter) {
        self.presenter = presenter
        
        idLabel.text     = "Message #\(presenter.idLabel)"
        userIdLabel.text = "UserId: \(presenter.userId)"
        titleLabel.text  = presenter.title
        bodyLabel.text   = presenter.body
    }
}
