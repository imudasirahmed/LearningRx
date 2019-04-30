//
//  LearningRx
//
//  Created by Mudasir Ahmed on 4/30/19.
//  Copyright © 2019 Mudasir Ahmed. All rights reserved.
//


import Foundation
import RxSwift

class SimpleRx {
    var bag = DisposeBag()
}

//MARK: - Variables
extension SimpleRx {
    
    static var shared = SimpleRx()
    
    func variables() {
        print("~~~~~~Variable~~~~~~")
        
        let someInfo = Variable("some value")
        print("someInfo.value: \(someInfo.value)")
        
        let plainString = someInfo.value
        print("plainString: \(plainString)") //"some value"
        
        someInfo.value = "something new"
        print("someInfo.value: \(someInfo.value)") //"something new"
        
        someInfo.asObservable().subscribe(onNext: { newValue in
            print("value has changed: \(newValue)")
        }, onDisposed: {
            //optional cleanup block
        }).disposed(by: bag)
        
        someInfo.value = "changed again"
        
        //NOTE: Variable will never receive onError, and onComplete events
    }
}

//MARK: - Subjects
extension SimpleRx {
    func subjects() {
        let behaviorSubject = BehaviorSubject(value: 24)
        
        let disposable = behaviorSubject.subscribe(onNext: { newValue in
            print("behaviorSubject subscription: \(newValue)")
        }, onError: { error in
            print("error: \(error.localizedDescription)")
        }, onCompleted: {
            print("completed")
        }, onDisposed: {
            print("disposed")
        })
        
        behaviorSubject.onNext(34)
        behaviorSubject.onNext(48)
        behaviorSubject.onNext(48) //duplicates show as a new event by default
        
        //1 on error
        //        let customError = CustomError.forcedError
        //        behaviorSubject.onError(customError) //will also trigger the dispose event
        //        behaviorSubject.onNext(109) //will never show
        
        //2 on completed
        //        behaviorSubject.onCompleted() //will also trigger the dispose event
        //        behaviorSubject.onNext(10983) //will never show
        
        //3 on dispose
        //        disposable.dispose()
        
        //4 can bind observables to subjects
        let numbers = Observable.from([1, 2, 3, 4, 5, 6, 7])
        numbers.subscribe(onNext: { number in
            print("Observable Subscription: \(number)")
        }).disposed(by: bag)
        
        numbers.bind(to: behaviorSubject).disposed(by: bag)
        
    }
}

//MARK: - Basic Observables
extension SimpleRx {
    func basicObservables() {
        //The observable
        let observerable = Observable<String>.create { observer in
            //The closure is called for every subscriber - by default
            print("~~ Observable logic being triggered ~~")
            
            
            //Do work on a background thread
            DispatchQueue.global().async {
                Thread.sleep(forTimeInterval: 1) //artificial delay
                
                observer.onNext("some value 23")
                observer.onCompleted()
            }
            
            return Disposables.create {
                //do something
                //network clean
                //fileio release
            }
        }
        
        observerable.subscribe(onNext: { someString in
            print("new value:  \(someString)")
        }).disposed(by: bag)
        
        let observer = observerable.subscribe(onNext: { someString in
            print("Another Subscriber: \(someString)")
        })
        
        observer.disposed(by: bag)
    }
    
    func creatingObservables() {
        //        let observable = Observable.just(23)
        //        let observable = Observable.from([1, 2, 3, 4, 5, 6, 7, 8, 9])
        let observable = Observable<Int>.interval(0.3, scheduler: MainScheduler.instance)
        
        observable.subscribe(onNext: { number in
            print(number)
        }, onCompleted: {
            print("No more elements... ever")
        }).disposed(by: bag)
    }
    
    func creatingUselessObservable() {
        var counter = 0
        let repeatable = Observable<String>.repeatElement("Over and over again")
        repeatable.subscribe{
            counter = counter + 1 //side effect
            print("\($0) - \(counter)")
            }.disposed(by: bag)
    }
}






