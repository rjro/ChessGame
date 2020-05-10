//
//  ChessPiece.swift
//  ChessGame
//
//  Created by Roger J. Romero on 5/9/20.
//  Copyright © 2020 Roger J. Romero. All rights reserved.
//

import Foundation
import UIKit

class ChessPiece {
    let tile: Tile
    let view: ChessPieceView
    
    init(tile: Tile, view: ChessPieceView) {
        self.tile = tile
        self.view = view
        self.view.piece = self
    }
}


class ChessPieceView: UIView {
    var piece: ChessPiece?
}
