//
//  StoreError.swift
//  Albuns
//
//  Created by Professor on 27/10/21.
//

import UIKit

enum DBError: Error {
    case falhaEmLerAlbum
    case falhaEmLerUsuario
    case falhaEmApagarAlbum
    case falhaAoSalvarDados
    case falhaEmApagarDados
}
