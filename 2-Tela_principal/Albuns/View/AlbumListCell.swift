//
//  AlbumListCell.swift  
//  Albuns
//
//  Created by Professor.
//  Copyright © 2021 Senai. All rights reserved.
//  

import Foundation
import UIKit

/// Classe que representa um Álbum a ser apresentado na lista da tela principal
class AlbumListCell: UITableViewCell {
    /// Declaração das referências aos componentes da tela
    @IBOutlet var albumLabel: UILabel!
    @IBOutlet var bandaLabel: UILabel!
    @IBOutlet weak var capaImg: UIImageView!
    
    /// Método utilizado para atribuir os valores aos campos do item da lista
    func configure(album: String, banda: String, capa: Data?) {
        albumLabel?.text = album
        bandaLabel?.text = banda
        if let aCapa = capa {
            capaImg.image = UIImage(data: aCapa)
        }
    }
}
