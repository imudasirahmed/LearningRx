//

import UIKit
import RxSwift
import RxCocoa

class ReactiveUIViewController: UIViewController {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var acceptButton: UIButton!
    
    fileprivate var presenter = ReactiveUIPresenter() //normally injected as an interface
    fileprivate var bag = DisposeBag()
    
    var mainThreadPointer: Thread!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainThreadPointer = Thread.current
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Default")
        
        //Regular DataSource
//        tableView.dataSource = self
        
        rxExamples()
    }
    
    @IBAction func acceptTapped(_ sender: UIButton) {
        print("Friends Accepted")
    }
}



//MARk: rxExamples()
extension ReactiveUIViewController {
    func rxExamples() {
        rxTitle()
        rxControls()
        rxTable2() //rxTable()
//        threading()
        threading2()
    }
}

//MARK: Rx Title
extension ReactiveUIViewController {
    func rxTitle() {
//        //Subscription
//        presenter.title.asObservable()
//                       .observeOn(MainScheduler.instance)
//                       .subscribe(onNext: { [weak self] title in
//                           self?.titleLabel.text = title
//                       }).disposed(by: bag)
//

        //Bind To
//        presenter.title.asObservable().bind(to: titleLabel.rx.text).disposed(by: bag)
//        presenter.title.asObservable()
////                       .observeOn(MainScheduler.instance)
////                       .catchErrorJustReturn("Default Value")
////                       .share(replay: 1, scope: .forever)
//                       .bind(to: titleLabel.rx.text)
//                       .disposed(by: bag)
        
        presenter.title.asDriver(onErrorJustReturn: "Default Value")
                       .drive(titleLabel.rx.text)
                       .disposed(by: bag)
    }
}

//MARK: Rx Controls
extension ReactiveUIViewController {
    func rxControls() {
        acceptButton.rx.tap.subscribe() { _ in
            print("accept button tapped")
        }.disposed(by: bag)
        
        presenter.friendsLoaded.asDriver().drive(acceptButton.rx.isEnabled).disposed(by: bag)
    }
}

//MARK: Rx Table
extension ReactiveUIViewController {
    func rxTable() {
        presenter.friends.asObservable()
                         .observeOn(MainScheduler.instance)
                         .subscribe(onNext: { [weak self] _ in
                             self?.tableView.reloadData()
                         }).disposed(by: bag)
    }
    
    func rxTable2() {
        presenter.friends.asObservable()
                         .bind(to: tableView.rx.items(cellIdentifier: "Default")) { (index, friend, cell: UITableViewCell) in
                             cell.textLabel?.text = friend.description
                         }.disposed(by: bag)
    }

}

/*
//MARK: - UITableViewDataSource
//extension ReactiveUIViewController: UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return presenter.friends.value.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let friend = presenter.friends.value[indexPath.row]
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Default", for: indexPath)
//            cell.textLabel?.text = friend.description
//
//        return cell
//    }
//}
*/

//MARK: UI Threading
extension ReactiveUIViewController {
    func threading() {
        presenter.friends.asObservable()
//            .observeOn(MainScheduler.instance)
            .subscribe { [weak self] _ in
                print("🚦 current thread: \(Thread.current)")
                print("⁉️ is on UI thread: \(self?.mainThreadPointer == Thread.current)")
                
                self?.tableView.reloadData()
            }.disposed(by: bag)
    }
    
    func threading2() {
        let observable = getResult()
        
        observable
            .observeOn(MainScheduler.instance)
//            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInteractive))
            .subscribe(onNext: { [weak self] result in
                print("Subscription: 🚦 current thread: \(Thread.current)")
                print("Subscription: ⁉️ is on UI thread: \(self?.mainThreadPointer == Thread.current)")
                print("result: \(result)")
            }).disposed(by: bag)
    }
    
    func getResult() -> Observable<String> {
        return Observable.create { [weak self] observer in
            Thread.sleep(forTimeInterval: 3)

            print("Observable: 🚦 current thread: \(Thread.current)")
            print("Observable: ⁉️ is on UI thread: \(self?.mainThreadPointer == Thread.current)")

            observer.onNext("some result")
            observer.onCompleted()
            
            
            return Disposables.create()
        }
    }
}











