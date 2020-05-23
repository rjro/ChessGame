//
//  ChessMove.swift
//  ChessGame
//
//  Created by Roger J. Romero on 5/23/20.
//  Copyright © 2020 Roger J. Romero. All rights reserved.
//

import Foundation

extension Chess {
	
	class Delta: TileDelta {
		let oldTile: Tile
		let newTile: Tile
		let piece: Chess.Piece
		
		init(piece: Chess.Piece, oldTile: Tile, newTile: Tile) {
			self.piece = piece
			self.oldTile = oldTile
			self.newTile = newTile
		}
	}
}
