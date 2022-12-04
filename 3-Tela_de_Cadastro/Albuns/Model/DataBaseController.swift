//
//  DataBaseController.swift
//  Albuns
//
//  Created by Professor.
//  Copyright © 2021 Senai. All rights reserved.
//


import UIKit
import CoreData

/// Classe que faz o gerenciamento dos dados dos álbuns
class DataBaseController: NSObject {
    /// Referência que permite o acesso a este objeto
    /// por toda a aplicação
    static let sharedInstance = DataBaseController()
    
    /// Método declarado com "fileprivate" para
    /// impedir a criação de objetos desta classe
    fileprivate override init() {
        super.init()
    }
    
    /// Referência do arquivo que armazena os álbuns.
    /// A declaração "lazy" permite que a inicialização
    /// desta referência ocorra somente quando for utilizada
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Albuns")
        container.loadPersistentStores(completionHandler: {
            (storeDescription, error) in
            if let error = error as NSError? {
                fatalError(
                    "Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    /// Referência ao Gerenciador de Objetos armazenadoem Banco de
    /// dados interno no dispositivo móvel.
    /// A declaração "lazy" permite que a inicialização
    /// desta referência ocorra somente quando for utilizada
    private lazy var managedObjectContext: NSManagedObjectContext = persistentContainer.viewContext
    
    /// Método que permite a criação de um novo registro vazio no Banco de dados.
    private func novoObjeto(_ object: String) -> NSManagedObject {
        let entity = NSEntityDescription.entity(forEntityName: object,
                                                in: self.managedObjectContext)!
        let registro = NSManagedObject(entity: entity,
                                       insertInto: managedObjectContext)
        
        return registro
    }

    /// Método que salva os objetos criados com o método "novoObjeto"
    /// e com seus dados armazenados pela aplicação.
    func salvar() throws {
        let context = managedObjectContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                NSLog(
                    "Unresolved error \(nserror), \(nserror.userInfo)")
                throw DBError.falhaAoSalvarDados
            }
        }
    }
    
    /// Método que remove um determinado registro a partir da referência informada
    func delete(_ entidade: Album) throws {
        do {
            managedObjectContext.delete(entidade)
            try salvar()
        } catch {
            throw DBError.falhaEmApagarAlbum
        }
    }
    
    /// Método que utiliza "novoObjeto" para criar uma nova instância de
    /// Álbum no banco de dados para ser utilizado pela aplicação
    func novoAlbum() -> Album {
        return novoObjeto("Album") as! Album
    }
    
    /// Método que retorna todos os Álbuns armazenados no Banco de Dados
    func albuns() throws -> [Album]! {
        do {
            let request = NSFetchRequest<NSFetchRequestResult>(
                entityName: "Album")
            request.sortDescriptors = [NSSortDescriptor(key: "nome",
                                                        ascending: true)]
            
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
    
    /// Método que retorna o Álbum armazenados no Banco de Dados
    /// cujo nome corresponde com o argumento informado
    func localizar(nome: String) throws -> Album! {
        do {
            let request = NSFetchRequest<NSFetchRequestResult>(
                entityName: "Album")
            request.predicate = NSPredicate(format: "nome = %@",
                                            argumentArray: [nome])
            request.fetchLimit = 1
            
            let results = try managedObjectContext.fetch(request)
            if results.count > 0 {
                return (results[0] as! Album)
            } else {
                return nil
            }
        } catch {
            throw DBError.falhaEmLerAlbum
        }

    }
}
