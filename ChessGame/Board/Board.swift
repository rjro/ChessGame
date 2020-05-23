//
//  Board.swift
//  ChessGame
//
//  Created by Roger J. Romero on 5/9/20.
//  Copyright © 2020 Roger J. Romero. All rights reserved.
//

import Foundation


typealias BoardSize = (rows: Int, columns: Int)

class Board {
	
	let size: BoardSize
	
	var state: [[Chess.Piece?]]
	var deltas = [Chess.Delta]()
	
	init(size: BoardSize) {
		self.size = size
		self.state = [[Chess.Piece?]](repeating: [Chess.Piece?](repeating: nil, count: size.columns), count: size.rows)
	}
	
	func occupations() -> [(Chess.Piece, Tile)] {
		
		var piecesAndLocations = [(Chess.Piece, Tile)]()
		
		for (row, rowPieces) in state.enumerated() {
			for (column, piece) in rowPieces.enumerated() {
				if let piece = piece {
					piecesAndLocations.append((piece, Tile(row: row, column: column)))
				}
			}
		}
		
		return piecesAndLocations
		
	}

	
	func isValidMove(oldTile: Tile, newTile: Tile) -> (validMove: Bool, capture: Bool) {
		let validMove = possibleMoves(tile: oldTile).contains(newTile)
		let capture = validMove ? isCapture(oldTile: oldTile, newTile: newTile) : false
		print("WAS VALID MOVE? WAS CAPTURE", validMove, capture)
		return (validMove, capture)
	}
	
	func haveDifferentOwners(tile: Tile, otherTile: Tile) -> Bool {
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
	
	
	//maybe refactor from this idea of "moves" into "deltas" that are consumed and
	//reduced into the state?
	func movePiece(oldTile: Tile, newTile: Tile) {
				
	
		guard let piece = state[oldTile.row][oldTile.column] else {
			fatalError("Attempting to move a piece that does not exist!")
		}
			
		deltas.append(Chess.Delta(piece: piece, oldTile: oldTile, newTile: newTile))
		
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

extension Board: TileState {
	
	func exists(_ tile: Tile) -> Bool {
		tile.row >= 0 && tile.column >= 0 && tile.row < size.rows && tile.column < size.columns
	}
	
	func isOccupied(_ tile: Tile) -> Bool {
		exists(tile) && nil != state[tile.row][tile.column]
	}
	
	func haveDifferentOwners(_ tile: Tile, _ otherTile: Tile) -> Bool {
		state[tile.row][tile.column]?.owner != state[otherTile.row][otherTile.column]?.owner
	}
	
	func owner(_ tile: Tile) -> Chess.Owner {
		return state[tile.row][tile.column]!.owner!
	}
	
}
