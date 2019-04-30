import Foundation
import RxSwift

class TasksExamplePresenter {
    
    let peopleInfo = Variable<[String]>([])
    
    var people = [Person(firstName: "Norris",     lastName: "Najar",     age: 0),
                  Person(firstName: "Dylan",      lastName: "Decarlo",   age: 1),
                  Person(firstName: "Sonny",      lastName: "Stecher",   age: 2),
                  Person(firstName: "Napoleon",   lastName: "Nicols",    age: 3),
                  Person(firstName: "Jinny",      lastName: "Jordahl",   age: 4),
                  Person(firstName: "Wendi",      lastName: "Woodhouse", age: 5)]
    
    let modelLayer = ModelLayer.shared
}

extension TasksExamplePresenter {
    
    func loadPeopleInfo() -> Observable<[String]> {
        return modelLayer.loadInfo(for: people)
    }
}

