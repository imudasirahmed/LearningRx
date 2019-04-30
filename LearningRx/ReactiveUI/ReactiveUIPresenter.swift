import Foundation
import RxSwift


//step 1
class ReactiveUIPresenter {
    
    let friends = Variable<[Friend]>([])
    let title   = BehaviorSubject(value: "") //Variable("")
    let friendsLoaded = Variable(false)
    
    init() {
        loadFriends()
    }
    
    func loadFriends() {
        title.onNext("Loading Friends")
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.title.onNext("Friends Loaded")
            self?.friendsLoaded.value = true
            
            var friends = [Friend(firstName: "Debi", lastName:"Darlington"),
                           Friend(firstName: "Arlie", lastName:"Abalos"),
                           Friend(firstName: "Jessica", lastName:"Jetton"),
                           Friend(firstName: "Tonia", lastName:"Threlkeld"),
                           Friend(firstName: "Donte", lastName:"Derosa"),
                           Friend(firstName: "Nohemi", lastName:"Notter"),
                           Friend(firstName: "Rod", lastName:"Rye"),
                           Friend(firstName: "Simonne", lastName:"Sala"),
                           Friend(firstName: "Kathaleen", lastName:"Kyles"),
                           Friend(firstName: "Loan", lastName:"Lawrie"),
                           Friend(firstName: "Elden", lastName:"Ellen"),
                           Friend(firstName: "Felecia", lastName:"Fortin"),
                           Friend(firstName: "Fiona", lastName:"Fiorini"),
                           Friend(firstName: "Joette", lastName:"July"),
                           Friend(firstName: "Beverley", lastName:"Bob"),
                           Friend(firstName: "Artie", lastName:"Aquino"),
                           Friend(firstName: "Yan", lastName:"Ybarbo"),
                           Friend(firstName: "Armando", lastName:"Araiza"),
                           Friend(firstName: "Dolly", lastName:"Delapaz"),
                           Friend(firstName: "Juliane", lastName:"Jobin")]
            
            DispatchQueue.main.async {
                self?.friends.value = friends
            }
        }
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 6) { [weak self] in
            self?.title.onError(CustomError.forcedError)
        }
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 7) { [weak self] in
            print("🚦 pushing new value")
            self?.title.onNext("new value")
        }
    }
    
    
    
}
