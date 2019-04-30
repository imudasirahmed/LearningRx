//
//  LearningRx
//
//  Created by Mudasir Ahmed on 4/30/19.
//  Copyright © 2019 Mudasir Ahmed. All rights reserved.
//


import UIKit
import RxSwift
import RxCocoa

private var DefaultCellId = "Default"

class DatabaseExampleViewController: UITableViewController {
    
    private let presenter = DatabaseExamplePresenter()
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: DefaultCellId)
    }
}
