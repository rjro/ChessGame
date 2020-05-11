//
//  Board.swift
//  ChessGame
//
//  Created by Roger J. Romero on 5/9/20.
//  Copyright © 2020 Roger J. Romero. All rights reserved.
//

import Foundation

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

typealias BoardSize = (rows: Int, columns: Int)

class Board {
	
	var moveMap: [Chess.Rank: (Tile)->[Tile]] {
		[
			.pawn: pawnMoves,
			.bishop: bishopMoves,
			.rook :rookMoves,
			.knight: knightMoves,
			.queen: queenMoves,
			.king: kingMoves,
		]
	}
	
	let size: BoardSize
	
	//maps the columns of the start row
	//which are rows 8 and 1 for opponent/player
	static let startRow: [Int: Chess.Rank] = [
		0: .rook,
		7: .rook,
		1: .knight,
		6: .knight,
		2: .bishop,
		5: .bishop,
		3: .queen,
		4: .knight,
	]
	
	
	
	var state: [[Piece?]]
	
	init(size: BoardSize) {
		self.size = size
		self.state = [[Piece?]](repeating: [Piece?](repeating: nil, count: size.columns), count: size.rows)
	}
	
	func occupations() -> [(Piece, Tile)] {
		
		var piecesAndLocations = [(Piece, Tile)]()
		
		for (row, rowPieces) in state.enumerated() {
			for (column, piece) in rowPieces.enumerated() {
				if let piece = piece {
					piecesAndLocations.append((piece, Tile(row: row, column: column)))
				}
			}
		}
		
		return piecesAndLocations
		
	}
	
	func isValidMove(oldTile: Tile, newTile: Tile) -> Bool {
		return possibleMoves(tile: oldTile).contains(newTile)
	}
	
	
	func possibleMoves(tile: Tile) -> [Tile] {
		
		guard tile.row < size.rows && tile.column < size.columns && tile.row >= 0 && tile.column >= 0 else {
			return [Tile]()
		}
		
		guard let piece = state[tile.row][tile.column] else {
			return [Tile]()
		}
		
		return moveMap[piece.rank]!(tile)
		
	}
	
	func tileExists(_ tile: Tile) -> Bool {
		tile.row >= 0 && tile.column >= 0 && tile.row < size.rows && tile.column < size.columns
	}
	
	func tileOccupied(_ tile: Tile) -> Bool {
		guard tileExists(tile) else {
			return false
		}
		return nil != state[tile.row][tile.column]
	}
	
	
	func movePiece(oldTile: Tile, newTile: Tile) {
		let piece = state[oldTile.row][oldTile.column]
		state[oldTile.row][oldTile.column] = nil
		state[newTile.row][newTile.column] = piece
		print(state[oldTile.row][oldTile.column])
	}
	
	func printBoard() {
		var boardString = ""
		for column in state {
			var rowString = ""
			
			for row in column {
				if let piece = row {
					rowString += "X,"
				} else {
					rowString += "0,"
				}
			}
			
			boardString += rowString + "\n"
		}
		
		print(boardString)
		
	}
	
	func homeSetup(color: Chess.Color) {
		//populate pawn row
		for column in 0 ..< size.columns {
			state[6][column] = Piece(rank: .pawn, color: color, owner: .player)
		}
		
		Chess.startRow.forEach { column, rank in
			state[7][column] = Piece(rank: rank, color: color, owner: .player)
		}
		
	}
	
	func opponentSetup(color: Chess.Color) {
		
		for column in 0 ..< size.columns {
			state[1][column] = Piece(rank: .pawn, color: color, owner: .opponent)
		}
		
		
		Chess.startRow.forEach { column, rank in
			state[0][column] = Piece(rank: rank, color: color, owner: .opponent)
		}
		
	}
	
}
