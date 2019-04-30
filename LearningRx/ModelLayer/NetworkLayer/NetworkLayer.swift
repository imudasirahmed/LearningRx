import Foundation
import Result
import RxSwift

class NetworkLayer {
    //Create a Task
    func getInfo(for person: Person, finished: @escaping (Result<String?, CustomError>) -> Void) {
        
        //Execute on Background thread
        //do your task here
        DispatchQueue.global().async {
            print("start network call: \(person)")
            let randomTime = TimeInterval(person.age)
            Thread.sleep(forTimeInterval: randomTime) //fake some work
            print("finished network call: \(person)")
            
            //just randomly make odd people nil
            let isEven = person.age % 2 == 0
            
            let result = isEven
                       ? person.description
                       : nil
            
//            if person.age == 0 {
//                finished(.failure(CustomError.ageZeroError))
//            } else {
                finished(.success(result))
//            }
        }
    }
    
    //Wrap task in observable
    //This pattern is used often for units of work
    private func buildGetInfoNetworkCall(for person: Person) -> Observable<String?> {
        return Observable.create { [weak self] observer in
            guard let strongSelf = self else { observer.onNext(nil) ; observer.onCompleted() ; return Disposables.create() }
            
            //Execute Request - Do actual work here
            strongSelf.getInfo(for: person) { result in
                switch result {
                case .success(let info):
                    observer.onNext(info) //push result
                    observer.onCompleted() //finish single unit of work
                case .failure(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create {
                //cleanup dependencies - in this case we have none
            }
        }
    }
    
    
    //Make observables for an array of people
    func loadInfo(for people: [Person]) -> Observable<[String]> {
        
        //Foreach person make network call
        let networkObservables = people.flatMap { person -> Observable<String?>? in
            let observable = buildGetInfoNetworkCall(for: person)
            return observable
        }
        
        //when all server results have returned zip observables into a single observable
        return Observable.zip(networkObservables) { infoList in
            print("🚦info before flatMape: \n\t\(infoList)")
            
            return infoList.flatMap { $0 }
        }
    }
}

