import UIKit
import RxSwift
import Result

class TasksExampleViewController: UIViewController {
    
    private let presenter = TasksExamplePresenter() //normally injected
    private var bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.loadPeopleInfo()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { infoList in
                print("🦄 all processes completed successfully")
                print("network results: \n\t\(infoList)")
            }, onError: { error in
                print("❗️not all processes completed successfully")
            }).disposed(by: bag)
    }
}
