//
//  AlbumModel.swift
//  Albuns
//
//  Created by Professor on 26/10/21.
//

import UIKit
import CoreData

class DataBaseController: NSObject {
    static let sharedInstance = DataBaseController()

    fileprivate override init() {
        super.init()
    }
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Albuns")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private lazy var managedObjectContext: NSManagedObjectContext = persistentContainer.viewContext

    private func novoObjeto(_ object: String) -> NSManagedObject {
        let entity = NSEntityDescription.entity(forEntityName: object, in: self.managedObjectContext)!
        let registro = NSManagedObject(entity: entity, insertInto: managedObjectContext)
        
        return registro
    }

    func salvar() throws {
        let context = managedObjectContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                throw DBError.falhaAoSalvarDados
            }
        }
    }

    func delete(_ entidade: NSManagedObject) throws {
        do {
            managedObjectContext.delete(entidade)
            try salvar()
        } catch {
            throw DBError.falhaEmApagarAlbum
        }
    }

    func novoAlbum() -> Album {
        return novoObjeto("Album") as! Album
    }
    
    func albuns() throws -> [Album]! {
        do {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Album")
            request.sortDescriptors = [NSSortDescriptor(key: "nome", ascending: true)]
            
            let results = try managedObjectContext.fetch(request)
            if results.count > 0 {
                return (results as! [Album])
            } else {
                return nil
            }
        } catch {
            throw DBError.falhaEmLerAlbum
        }
    }
     
    func localizar(nome: String) throws -> Album! {
        do {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Album")
            request.predicate = NSPredicate(format: "nome = %@", argumentArray: [nome])
            request.fetchLimit = 1
            
            let results = try managedObjectContext.fetch(request)
            if results.count > 0 {
                return (results[0] as! Album)
            } else {
                return nil
            }
        } catch {
            throw DBError.falhaEmLerUsuario
        }
    }
}

