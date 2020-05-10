//
//  Board.swift
//  ChessGame
//
//  Created by Roger J. Romero on 5/9/20.
//  Copyright © 2020 Roger J. Romero. All rights reserved.
//

import Foundation


struct Piece {
	let rank: ChessRank
	let owner = 0
}


enum ChessRank {
	case pawn, knight, rook, bishop, queen, king
}


typealias BoardSize = (rows: Int, columns: Int)

class Board {
	let size: BoardSize
	
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
		
		
		switch piece.rank {
		case .bishop: return bishopMoves(tile: tile)
			
		case .pawn: return pawnMoves(tile: tile)
		case .knight: return knightMoves(tile: tile)
		default: return [Tile]()
		}
		
	}
	
	private func tileExists(_ tile: Tile) -> Bool {
		tile.row >= 0 && tile.column >= 0 && tile.row < size.rows && tile.column < size.columns
	}
	
	private func tileOccupied(_ tile: Tile) -> Bool {
		guard tileExists(tile) else {
			return false
		}
		return nil != state[tile.row][tile.column]
	}
	
	func knightMoves(tile: Tile) -> [Tile] {
		print("CALLED!")
		var moves = [Tile]()
		
		let deltas: [(Int, Int)] = [
			(-2,-1),
			(-1,-2),
			
			(-2,1),
			(-1,2),
			
			(2,1),
			(1,2),
			
			(2,-1),
			(1,-2),

		]
		
		for (dr, dc) in deltas {
			let newTile = Tile(row: tile.row+dr, column: tile.column+dc)
			if tileExists(newTile) {
				moves.append(newTile)
			}
		}
		
		
		return moves
		
	}
	
	func bishopMoves(tile: Tile) -> [Tile] {
		var moves = [Tile]()
		
		var moverTile = tile
		
		while tileExists(moverTile) {
			moves.append(moverTile)
			moverTile.row += 1
			moverTile.column += 1
			if tileOccupied(moverTile) { break }
		}
		moverTile = tile
		
		while tileExists(moverTile) {
			moves.append(moverTile)
			moverTile.row -= 1
			moverTile.column -= 1
			if tileOccupied(moverTile) { break }
			
		}
		
		moverTile = tile
		
		while tileExists(moverTile) {
			moves.append(moverTile)
			moverTile.row -= 1
			moverTile.column += 1
			if tileOccupied(moverTile) { break }
			
		}
		
		moverTile = tile
		
		while tileExists(moverTile) {
			moves.append(moverTile)
			moverTile.row += 1
			moverTile.column -= 1
			if tileOccupied(moverTile) { break }
			
		}
		
		
		return moves
	}
	
	func pawnMoves(tile: Tile) -> [Tile] {
		return [
			(-1, 0),
			(-2, 0),
			//	(-1, -1),
			//		(-1, +1),
			].map { (dr, dc) in
				Tile(row: tile.row+dr, column: tile.column+dc)
		}
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
	
	func homeSetup() {
		//populate pawn row
		for column in 0 ..< size.columns {
			state[6][column] = Piece(rank: .pawn)
		}
		
		state[7][0] = Piece(rank: .rook)
		state[7][7] = Piece(rank: .rook)
		
		state[7][1] = Piece(rank: .knight)
		state[7][6] = Piece(rank: .knight)
		
		state[7][2] = Piece(rank: .bishop)
		state[7][5] = Piece(rank: .bishop)
		
		state[7][3] = Piece(rank: .king)
		state[7][4] = Piece(rank: .queen)

	}
		
}
