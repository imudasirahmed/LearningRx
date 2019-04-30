import UIKit
import RxSwift
import RxCocoa

class NetworkExampleViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    fileprivate var presenter = NetworkExamplePresenter()
    fileprivate var bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkExampleTableViewCell.register(with: tableView)
        
        rxDataSourceSetup()
    }
}

//MARK: - Rx DataSource Setup
extension NetworkExampleViewController {
    func rxDataSourceSetup() {
        presenter.messages
                 .asObservable()
                 .observeOn(MainScheduler.instance)
                 .bind(to: tableView.rx.items(cellIdentifier: NetworkExampleTableViewCell.cellId)) { (index, message, cell: NetworkExampleTableViewCell) in
                        let cellPresenter = NetworkExampleTableCellPresenter(message: message)
                        cell.configure(with: cellPresenter)
                 }.disposed(by: bag)
        
        tableView.rx.setDelegate(self).disposed(by: bag)
    }
}


extension NetworkExampleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
}
