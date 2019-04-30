import UIKit
import AVKit

enum ExampleType: String {
    case basic,
         tasks,
         reactiveUI,
         networking
}

class ExamplesTableViewController: UITableViewController {
    
    let examples: [ExampleType] = [.basic, .networking, .tasks, .reactiveUI]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "default")
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return examples.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "default", for: indexPath)
            cell.textLabel?.text = examples[indexPath.row].rawValue

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = getVC(for: examples[indexPath.row])
        navigationController?.pushViewController(vc, animated: true)
    }
    
    fileprivate func getVC(for type: ExampleType) -> UIViewController {
        switch type {
        case .basic:
            return BasicExampleViewController()
        case .tasks:
            return TasksExampleViewController()
        case .reactiveUI:
            return ReactiveUIViewController()
        case .networking:
            return NetworkExampleViewController()
        }
    }
}
