import Foundation
import RxSwift

//Mark: - Traits
class TraitsRx {
    
    static var shared = TraitsRx()
    
    private var bag = DisposeBag()
    
    func traits_single() {
        let single = Single<String>.create { single -> Disposable in
            //do some logic here
            let success = true
            
            
            if success { //return a value
                single(.success("nice work!"))
            } else {
                let error = CustomError.forcedError
                single(.error(error))
            }
            
            return Disposables.create()
        }
        
        single.subscribe(onSuccess: { result in
            //do something with result
            print("single: \(result)")
        }, onError: { error in
            //do something for error
        }).disposed(by: bag)
    }
    
    func traits_completable() {
        
        let completable = Completable.create { completable -> Disposable in
            //do logic here
            let success = true
            
            if success {
                completable(.completed)
            } else {
                let error = CustomError.forcedError
                completable(.error(error))
            }
            
            return Disposables.create()
        }
        
        completable.subscribe(onCompleted: {
            //handle on complete
            print("Completable completed")
        }, onError:{ error in
            //do something for error
        }).disposed(by: bag)
        
    }
    
    func traits_maybe() {
        let maybe = Maybe<String>.create { maybe in
            //do something
            let success = true
            let hasResult = true
            
            
            if success {
                if hasResult {
                    maybe(.success("some result"))
                } else {
                    maybe(.completed) //no result
                }
            } else {
                let someError = CustomError.forcedError
                maybe(.error(someError))
            }
            
            return Disposables.create()
        }
        
        maybe.subscribe(onSuccess: { result in
            //do something with result
            print("Maybe - result: \(result)")
        }, onError: { error in
            //do something with the error
        }, onCompleted: {
            //do something about completing
            print("Maybe - completed")
        }).disposed(by: bag)
    }
    
}
