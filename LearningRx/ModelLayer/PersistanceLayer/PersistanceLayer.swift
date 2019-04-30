//
//  LearningRx
//
//  Created by Mudasir Ahmed on 4/30/19.
//  Copyright © 2019 Mudasir Ahmed. All rights reserved.
//

import Foundation
import CoreData
import RxSwift
import Outlaw

class PersistanceLayer {

    static var shared = PersistanceLayer() 
    
    var databaseReady = Variable(false)
    var bag = DisposeBag()

    private var recordLimit = 1000
    
    var randomHexString: String {
        let baseIntA = Int(arc4random() % 16777215)
        let str = String(format: "%06X", baseIntA)
        return str
    }

    func preloadDatabase(finish:@escaping () -> Void) {
        
        let entities = loadDBJSON()
        
        //act like we are parsing and creating new objects
        self.persistentContainer.performBackgroundTask{ context in
            var photos = [PhotoDescription]()
            
            for i in 0 ... self.recordLimit {
                let entity = entities[i]

                let photoDescription = TranslationLayer.shared.convert(entity: entity, context: context)
                
                photos.append(photoDescription)  //retain it through the for loop
            }
            
            try! context.save()
            
            DispatchQueue.main.async {
                finish()
            }
        }
    }

    //func loadAllPhotoDescriptors() -> [PhotoDescription] { //sync api
    func loadAllPhotoDescriptions(finished: @escaping PhotoDescriptionsClosure) { //async api
        
        databaseReady.asObservable().subscribe(onNext: { isReady in
            guard isReady else { return }
            
            //assume a large data set in backend
            DispatchQueue.global().async { [weak self] in
                guard let strongSelf = self else { return }
                
                let sort = NSSortDescriptor(key:"id", ascending: true)
                
                let fetchRequest: NSFetchRequest<PhotoDescription> = PhotoDescription.fetchRequest()
                fetchRequest.sortDescriptors = [sort]
                
                let photoDescriptions = try! strongSelf.persistentContainer.viewContext.fetch(fetchRequest)
                
                finished(photoDescriptions)
            }

        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: bag)
    }

    //MARK: - Helper Methods
    func initDatabase() {
        DispatchQueue.global().async {
            self.clearOldResults()
            self.preloadDatabase {
                self.databaseReady.value = true
            }
        }
    }
    
    func clearOldResults() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "PhotoDescription") // = PhotoDescription.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        //I want this to crash if I can't get a clean slate for the examples
        try! persistentContainer.persistentStoreCoordinator.execute(deleteRequest, with: persistentContainer.viewContext)
        
        persistentContainer.viewContext.reset()
    }

    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "DatabaseExample")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func loadDBJSON() -> [PhotoDescriptionEntity] {
        let url = Bundle.main.url(forResource: "PhotoDescription", withExtension: "json")!
        let photoDescriptions: [PhotoDescriptionEntity] = try! JSON.value(from: url)
        
        return photoDescriptions
    }
}
