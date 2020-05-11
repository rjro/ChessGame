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
		
		
		switch piece.rank {
		case .bishop: return bishopMoves(tile: tile)
			
		case .pawn: return pawnMoves(tile: tile)
		case .knight: return knightMoves(tile: tile)
		case .rook: return rookMoves(tile: tile)
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
			if tileExists(newTile) && !tileOccupied(newTile) {
				moves.append(newTile)
			}
		}
		
		
		return moves
		
	}
	
	func bishopMoves(tile: Tile) -> [Tile] {
		var moves = [Tile]()
		
		var moverTile = Tile(row: tile.row+1, column: tile.column+1)
		
		while tileExists(moverTile) && !tileOccupied(moverTile) {
			moves.append(moverTile)
			moverTile.row += 1
			moverTile.column += 1
			if tileOccupied(moverTile) { break }
		}
		
		moverTile = Tile(row: tile.row-1, column: tile.column-1)
		
		while tileExists(moverTile) && !tileOccupied(moverTile) {
			moves.append(moverTile)
			moverTile.row -= 1
			moverTile.column -= 1
			if tileOccupied(moverTile) { break }
			
		}
		
		moverTile = Tile(row: tile.row-1, column: tile.column+1)
		
		while tileExists(moverTile) && !tileOccupied(moverTile) {
			moves.append(moverTile)
			moverTile.row -= 1
			moverTile.column += 1
			if tileOccupied(moverTile) { break }
			
		}
		
		moverTile = Tile(row: tile.row+1, column: tile.column-1)
		
		while tileExists(moverTile) && !tileOccupied(moverTile) {
			moves.append(moverTile)
			moverTile.row += 1
			moverTile.column -= 1
			if tileOccupied(moverTile) { break }
			
		}
		
		
		return moves
	}
	
	func pawnMoves(tile: Tile) -> [Tile] {
		
		var moves = [Tile]()
		
		guard let currentPiece = state[tile.row][tile.column],
			let owner = currentPiece.owner,
			currentPiece.rank == .pawn else {
				return moves
		}
		
		if owner == .player {
			let up = Tile(row: tile.row-1, column: tile.column)
			let twoUp = Tile(row: tile.row-2, column: tile.column)
			if tileExists(up) && !tileOccupied(up) { moves.append(up) }
			if tileExists(twoUp) && !tileOccupied(twoUp) { moves.append(twoUp) }
		} else {
			let down = Tile(row: tile.row+1, column: tile.column)
			let twoDown = Tile(row: tile.row+2, column: tile.column)
			if tileExists(down) && !tileOccupied(down) { moves.append(down) }
			if tileExists(twoDown) && !tileOccupied(twoDown) { moves.append(twoDown) }
		}
		
		return moves
	}
	
	func rookMoves(tile: Tile) -> [Tile] {
		var moves = [Tile]()
		
		var moverTile = Tile(row: tile.row-1, column: tile.column)
		
		while tileExists(moverTile) && !tileOccupied(moverTile) {
			moves.append(moverTile)
			moverTile.row -= 1
			if tileOccupied(moverTile) { break }
		}
		
		moverTile = Tile(row: tile.row+1, column: tile.column)
		
		while tileExists(moverTile) && !tileOccupied(moverTile) {
			moves.append(moverTile)
			moverTile.row += 1
			if tileOccupied(moverTile) { break }
		}
		
		
		moverTile = Tile(row: tile.row, column: tile.column+1)
		
		while tileExists(moverTile) && !tileOccupied(moverTile) {
			moves.append(moverTile)
			moverTile.column += 1
			if tileOccupied(moverTile) { break }
		}
		
		moverTile = Tile(row: tile.row, column: tile.column-1)
		
		while tileExists(moverTile) && !tileOccupied(moverTile) {
			moves.append(moverTile)
			moverTile.column -= 1
			if tileOccupied(moverTile) { break }
		}
		
		return moves
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
