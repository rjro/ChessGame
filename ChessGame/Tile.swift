//
//  Tile.swift
//  ChessGame
//
//  Created by Roger J. Romero on 5/9/20.
//  Copyright © 2020 Roger J. Romero. All rights reserved.
//

import Foundation

enum TileParity {
	case even, odd
}

struct Tile {
	let row: Int
	let column: Int
	
	var parity: TileParity {
		if (row+column).isMultiple(of: 2) {
			return .even
		} else {
			return .odd
		}
	}
	
}


