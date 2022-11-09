//
//  DBError.swift  
//  Albuns
//
//  Created by Professor.
//  Copyright © 2021 Senai. All rights reserved.
//  

import Foundation

/// Enumeração que descreve os possíveis erros
/// que possam ocorrer na aplicação
enum DBError: Error {
    case falhaEmLerAlbum
    case falhaEmApagarAlbum
    case falhaAoSalvarDados
}
