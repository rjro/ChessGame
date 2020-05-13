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
	
	enum MoveResult {
		case valid, invalid, capture
	}
	
	func isValidMove(oldTile: Tile, newTile: Tile) -> (validMove: Bool, capture: Bool) {
		let validMove = possibleMoves(tile: oldTile).contains(newTile)
		let capture = validMove ? isCapture(oldTile: oldTile, newTile: newTile) : false
		return (validMove, capture)
	}
	
	func tilesHaveDifferentOwners(tile: Tile, otherTile: Tile) -> Bool {
		state[tile.row][tile.column]?.owner != state[otherTile.row][otherTile.column]?.owner
	}
	
	func isCapture(oldTile: Tile, newTile: Tile) -> Bool {
		//TODO: Check capture rules!
		let occupied = isTileOccupied(newTile)
		
		guard occupied else {
			return false
		}

		state[newTile.row][newTile.column] = nil
		return true
	}
	
	func isTileOccupied(_ tile: Tile) -> Bool {
		nil != state[tile.row][tile.column]
	}
	
	
	func possibleMoves(tile: Tile) -> [Tile] {
		guard tile.row < size.rows && tile.column < size.columns && tile.row >= 0 && tile.column >= 0 else {
			return [Tile]()
		}
		
		guard let piece = state[tile.row][tile.column] else {
			return [Tile]()
		}
		
		//figure out a way so the dictionary for the enum isn't an optional
		return moveMap[piece.rank]?(tile) ?? [Tile]()
	}
	
	func tileExists(_ tile: Tile) -> Bool {
		tile.row >= 0 && tile.column >= 0 && tile.row < size.rows && tile.column < size.columns
	}
	func tileOccupied(_ tile: Tile) -> Bool {
		tileExists(tile) && nil != state[tile.row][tile.column]
	}

	func movePiece(oldTile: Tile, newTile: Tile) {
		let piece = state[oldTile.row][oldTile.column]
		state[oldTile.row][oldTile.column] = nil
		state[newTile.row][newTile.column] = piece
		print(state[oldTile.row][oldTile.column] ?? "piece now empty")
	}
	
	func printBoard() {
		var boardString = ""
		for column in state {
			var rowString = ""
			
			for row in column {
				if nil != row {
					rowString += "X,"
				} else {
					rowString += "0,"
				}
			}
			
			boardString += rowString + "\n"
		}
		
		print(boardString)
		
	}
	
}
