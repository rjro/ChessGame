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
	
}
