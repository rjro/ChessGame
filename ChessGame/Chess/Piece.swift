//
//  ChessPiece.swift
//  ChessGame
//
//  Created by Roger J. Romero on 5/18/20.
//  Copyrigt © 2020 Roger J. Romero. All rights reserved.
//

import Foundation

extension Chess {
	struct Piece {
		let rank: Chess.Rank
		let color: Chess.Color
		var owner: Chess.Owner?
		
		init(rank: Chess.Rank, color: Chess.Color, owner: Chess.Owner? = nil) {
			self.rank = rank
			self.color = color
			self.owner = owner
		}
		
	}
}
