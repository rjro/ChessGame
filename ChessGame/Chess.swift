//
//  Chess.swift
//  ChessGame
//
//  Created by Roger J. Romero on 5/10/20.
//  Copyright © 2020 Roger J. Romero. All rights reserved.
//

import Foundation

enum Chess {
	
	static let startRow: [Int: Chess.Rank] = [
		0: .rook,
		7: .rook,
		1: .knight,
		6: .knight,
		2: .bishop,
		5: .bishop,
		3: .queen,
		4: .king,
	]
	
	enum Owner {
		case player, opponent
	}
	
	enum Color {
		case black, white
	}
	
	enum Rank {
		case pawn, knight, rook, bishop, queen, king
	}
	
	static func setupBoard(board: Board) {
		for column in 0 ..< board.size.columns {
			board.state[6][column] = Piece(rank: .pawn, color: .black, owner: .player)
			board.state[1][column] = Piece(rank: .pawn, color: .white, owner: .opponent)
		}
		
		Chess.startRow.forEach { column, rank in
			board.state[7][column] = Piece(rank: rank, color: .black, owner: .player)
			board.state[0][column] = Piece(rank: rank, color: .white, owner: .opponent)
		}
		
	}
	
}
