//
//  AlbumViewController.swift
//  Albuns
//
//  Created by Professor on 23/10/21.
//

import UIKit

protocol AlbumModelChangedDelegate {
    func albumModelChanged()
}

class AlbumViewController: UITableViewController, AlbumModelChangedDelegate {
    static let showAlbumDetalheSegueIdentifier = "ShowAlbumDetalheSegue"
    let dataBase = DataBaseController.sharedInstance
    var albuns: [Album]!
    enum Estado {
        case normal
        case vazio
        case erro
    }
    var estado = Estado.vazio
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        do {
            albuns = try dataBase.albuns()

            if albuns != nil {
                estado = .normal
                self.navigationItem.rightBarButtonItem = self.editButtonItem
                editButtonItem.title = "Editar"
            }
        } catch {
            estado = .erro
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        switch estado {
        case .vazio:
            alert("Sem Álbuns cadastrados", message: "Não existem Álbuns cadastrados até o momento")
        case .erro:
            alert("Falha ao acesso aos dados", message: "Os dados dos Álbuns não puderam ser recuperados")
        default:
            break
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.editButtonItem.title = editing ? "Concluir" : "Editar"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Voltar"
        navigationItem.backBarButtonItem = backItem

        if segue.identifier == Self.showAlbumDetalheSegueIdentifier,
            let destination = segue.destination as? AlbumDetalheViewController {
            if let cell = sender as? UITableViewCell,
               let indexPath = tableView.indexPath(for: cell) {
                let album = albuns[indexPath.row]
                destination.configure(with: album, delegate: self)
            } else {
                destination.configure(with: nil, delegate: self)
            }
        }
    }
    
    func albumModelChanged() {
        do {
            albuns = try dataBase.albuns()
            tableView.reloadData()
        } catch {
            alert("Falha ao acesso aos dados", message: "Os dados dos Álbuns não puderam ser recuperados")
        }
    }
    
    @IBAction func incluir(_ sender: Any) {
        performSegue(withIdentifier: Self.showAlbumDetalheSegueIdentifier, sender: self)
    }

}

extension AlbumViewController {
    static let albumListCellIdentifier = "AlbumListCell"

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albuns != nil ? albuns.count : 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Self.albumListCellIdentifier, for: indexPath) as? AlbumListCell else {
            fatalError("Erro ao localizar o AlbumCell")
        }
        
        let album = albuns[indexPath.row]
        cell.configure(album: album.nome!, banda: album.banda!, capa: album.capa)
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // cria um alerta
            let alert = UIAlertController(title: "Atenção", message: "Confirma a exclusão do Álbum?", preferredStyle: .actionSheet)
            // add the actions (buttons)
            alert.addAction(UIAlertAction(title: "Confirma", style: .destructive, handler: { [self] (action: UIAlertAction) -> Void in
                do {
                    try dataBase.delete(albuns[indexPath.row])
                    albuns = try dataBase.albuns()
                    tableView.beginUpdates()
                    tableView.deleteRows(at: [indexPath], with: .left)
                    tableView.endUpdates()
                } catch {
                    self.alert("Fala ao acesso aos dados", message: "A ação não pode ser executada por problemas no armazenamento dos dados")
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancela", style: .cancel, handler:  nil))

            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
    }
}
