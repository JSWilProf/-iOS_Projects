//
//  AlbumListCell.swift
//  Albuns
//
//  Created by Professor on 23/10/21.
//

import UIKit

typealias VoidAction = () -> Void

class AlbumListCell: UITableViewCell {
    @IBOutlet var albumLabel: UILabel!
    @IBOutlet var bandaLabel: UILabel!
    @IBOutlet weak var capaImg: UIImageView!
    
    func configure(album: String, banda: String, capa: Data?) {
        albumLabel.text = album
        bandaLabel.text = banda
        if let aCapa = capa {
            capaImg.image = UIImage(data: aCapa)
        }
    }
}
