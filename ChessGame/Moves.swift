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
			if tileExists(newTile) && !tileOccupied(newTile) {
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
			let topLeft = Tile(row: tile.row-1, column: tile.column-1)
			let topRight = Tile(row: tile.row-1, column: tile.column+1)
			
			if tileExists(up) && !tileOccupied(up) { moves.append(up) }
			if tileExists(twoUp) && !tileOccupied(twoUp) { moves.append(twoUp) }
			
			if tileExists(topLeft) && tileOccupied(topLeft) && tilesHaveDifferentOwners(tile: tile, otherTile: topLeft) {
				moves.append(topLeft)
			}
			
			if tileExists(topRight) && tileOccupied(topRight) && tilesHaveDifferentOwners(tile: tile, otherTile: topRight) {
				moves.append(topRight)
			}
			
		} else {
			let down = Tile(row: tile.row+1, column: tile.column)
			let twoDown = Tile(row: tile.row+2, column: tile.column)
			let bottomLeft = Tile(row: tile.row+1, column: tile.column-1)
			let bottomRight = Tile(row: tile.row+1, column: tile.column+1)

			
			if tileExists(down) && !tileOccupied(down) { moves.append(down) }
			if tileExists(twoDown) && !tileOccupied(twoDown) { moves.append(twoDown) }
		
			
			if tileExists(bottomLeft) && tileOccupied(bottomLeft) && tilesHaveDifferentOwners(tile: tile, otherTile: bottomLeft) {
				moves.append(bottomLeft)
			}
			
			if tileExists(bottomRight) && tileOccupied(bottomRight) && tilesHaveDifferentOwners(tile: tile, otherTile: bottomRight) {
				moves.append(bottomRight)
			}
		
		}
		
		
		
		
		return moves
	}
	
	
	//maybe convert this to BFS???
	func rookMoves(tile: Tile) -> [Tile] {
		var moves = [Tile]()
		
		var moverTile = Tile(row: tile.row-1, column: tile.column)
		
		while tileExists(moverTile) {
			if tileOccupied(moverTile)  {
				if tilesHaveDifferentOwners(tile: tile, otherTile: moverTile) { moves.append(moverTile) }
				break

			}
			
			moves.append(moverTile)
			moverTile.row -= 1
		}
		
		moverTile = Tile(row: tile.row+1, column: tile.column)
		
		while tileExists(moverTile) {
			if tileOccupied(moverTile)  {
				if tilesHaveDifferentOwners(tile: tile, otherTile: moverTile) { moves.append(moverTile) }
				break
			}
			moves.append(moverTile)
			moverTile.row += 1
		}
		
		moverTile = Tile(row: tile.row, column: tile.column+1)
		
		while tileExists(moverTile) {
			if tileOccupied(moverTile)  {
				if tilesHaveDifferentOwners(tile: tile, otherTile: moverTile) { moves.append(moverTile) }
				break
			}
			moves.append(moverTile)
			moverTile.column += 1
		}
		
		moverTile = Tile(row: tile.row, column: tile.column-1)
		
		while tileExists(moverTile) {
			if tileOccupied(moverTile)  {
				if tilesHaveDifferentOwners(tile: tile, otherTile: moverTile) { moves.append(moverTile) }
				break
			}
			moves.append(moverTile)
			moverTile.column -= 1
		}
		
		return moves
	}
	
}
