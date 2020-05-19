//
//  Moves.swift
//  ChessGame
//
//  Created by Roger J. Romero on 5/10/20.
//  Copyright © 2020 Roger J. Romero. All rights reserved.
//

import Foundation



//possibleMoves needs to include pawns ability to En passant

//movePiece(oldTile: Tile, newTile: Tile) -> Captured: Bool


extension Board {
	
	var moveMap: [Chess.Rank: (Tile) -> [Tile] ] {
		[
			.pawn: pawnMoves,
			.bishop: bishopMoves,
			.rook :rookMoves,
			.knight: knightMoves,
			.queen: queenMoves,
			.king: kingMoves,
		]
	}
	
	func queenMoves(tile: Tile) -> [Tile] {
		Array(Set(rookMoves(tile: tile) + bishopMoves(tile: tile)))
	}
	
	func kingMoves(tile: Tile) -> [Tile] {
		var moves = [Tile]()
		
		let deltas: [(Int, Int)] = [
			(-1, -1),
			(+1, +1),
			(-1, 0),
			(+1, 0),
			(0, -1),
			(0, +1),
			(-1, +1),
			(+1, -1),
		]
		
		for (dr, dc) in deltas {
			let newTile = Tile(row: tile.row+dr, column: tile.column+dc)
			if exists(newTile) && !isOccupied(newTile) {
				moves.append(newTile)
			}
		}
		
		return moves
	}
	
	func knightMoves(tile: Tile) -> [Tile] {
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
			if exists(newTile) && !isOccupied(newTile) {
				moves.append(newTile)
			}
		}
		
		
		return moves
		
	}
	
	func bishopMoves(tile: Tile) -> [Tile] {
		var moves = [Tile]()
		
		var moverTile = Tile(row: tile.row+1, column: tile.column+1)
		
		while exists(moverTile) && !isOccupied(moverTile) {
			moves.append(moverTile)
			moverTile.row += 1
			moverTile.column += 1
			if isOccupied(moverTile) { break }
		}
		
		moverTile = Tile(row: tile.row-1, column: tile.column-1)
		
		while exists(moverTile) && !isOccupied(moverTile) {
			moves.append(moverTile)
			moverTile.row -= 1
			moverTile.column -= 1
			if isOccupied(moverTile) { break }
			
		}
		
		moverTile = Tile(row: tile.row-1, column: tile.column+1)
		
		while exists(moverTile) && !isOccupied(moverTile) {
			moves.append(moverTile)
			moverTile.row -= 1
			moverTile.column += 1
			if isOccupied(moverTile) { break }
			
		}
		
		moverTile = Tile(row: tile.row+1, column: tile.column-1)
		
		while exists(moverTile) && !isOccupied(moverTile) {
			moves.append(moverTile)
			moverTile.row += 1
			moverTile.column -= 1
			if isOccupied(moverTile) { break }
			
		}
		
		
		return moves
	}
	
	func pawnMoves(tile: Tile) -> [Tile] { Chess.Moves.pawn(tile: tile, state: self) }
	
	
	//maybe convert this to BFS???
	func rookMoves(tile: Tile) -> [Tile] {
		var moves = [Tile]()
		
		var moverTile = Tile(row: tile.row-1, column: tile.column)
		
		while exists(moverTile) {
			if isOccupied(moverTile)  {
				if haveDifferentOwners(tile: tile, otherTile: moverTile) { moves.append(moverTile) }
				break

			}
			
			moves.append(moverTile)
			moverTile.row -= 1
		}
		
		moverTile = Tile(row: tile.row+1, column: tile.column)
		
		while exists(moverTile) {
			if isOccupied(moverTile)  {
				if haveDifferentOwners(tile: tile, otherTile: moverTile) { moves.append(moverTile) }
				break
			}
			moves.append(moverTile)
			moverTile.row += 1
		}
		
		moverTile = Tile(row: tile.row, column: tile.column+1)
		
		while exists(moverTile) {
			if isOccupied(moverTile)  {
				if haveDifferentOwners(tile: tile, otherTile: moverTile) { moves.append(moverTile) }
				break
			}
			moves.append(moverTile)
			moverTile.column += 1
		}
		
		moverTile = Tile(row: tile.row, column: tile.column-1)
		
		while exists(moverTile) {
			if isOccupied(moverTile)  {
				if haveDifferentOwners(tile: tile, otherTile: moverTile) { moves.append(moverTile) }
				break
			}
			moves.append(moverTile)
			moverTile.column -= 1
		}
		
		return moves
	}
	
}
