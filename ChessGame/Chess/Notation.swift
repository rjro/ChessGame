//
//  Notation.swift
//  ChessGame
//
//  Created by Roger J. Romero on 5/23/20.
//  Copyright © 2020 Roger J. Romero. All rights reserved.
//

import Foundation

extension Chess {
	struct Coordinate: CustomStringConvertible {
		let file: String
		let rank: Int
		var description: String { "\(file)\(rank)" }
	}
}

extension Chess {
	enum Notation {
		
		static let Files = ["a", "b", "c", "d", "e", "f", "g", "h"]
		static let Ranks = [8, 7, 6, 5, 4, 3, 2, 1]
		
		static let RankToRow: [Int: Int] = [
			8 : 0,
			7 : 1,
			6 : 2,
			5 : 3,
			4 : 4,
			3 : 5,
			2 : 6,
			1 : 7
		]
		
		static let FileToColumn: [String : Int] = [
			"a" : 0,
			"b" : 1,
			"c" : 2,
			"d" : 3,
			"e" : 4,
			"f" : 5,
			"g" : 6,
			"h" : 7
		]
		
		static func tileToCoordinate(tile: Tile) -> Coordinate {
			Coordinate(file: Self.Files[tile.column], rank: Self.Ranks[tile.row])
		}
		
		static func CoordinateToTile(coordinate: Coordinate) -> Tile {
			Tile(row: Self.RankToRow[coordinate.rank]!, column: Self.FileToColumn[coordinate.file]!)
		}
	}
}
