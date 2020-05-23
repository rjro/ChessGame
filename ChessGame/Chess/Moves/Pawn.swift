//
//  Pawn.swift
//  ChessGame
//
//  Created by Roger J. Romero on 5/18/20.
//  Copyright © 2020 Roger J. Romero. All rights reserved.
//

import Foundation

extension Chess.Moves {
	
	//need to know if the piece is owned by the user that started the piece
	//to know if double moves are possible

	//TODO: en passant!!
	static func pawn(tile: Tile, state: TileState) -> [Tile] {
		var moves = [Tile]()
		
		let step = Chess.Moves.step(tile, state)
		let doubleStep = Chess.Moves.doubleStep(tile, state)
		
		if state.exists(step) && !state.isOccupied(step) {
			moves.append(step)
			
			if state.exists(doubleStep)
				&& onOriginalTile(tile, state)
				&& !state.isOccupied(doubleStep) {
				moves.append(doubleStep)
			}
		}
		
		for diagonal in diagonals(tile, state) {
			if state.exists(diagonal)
				&& state.isOccupied(diagonal)
				&& state.haveDifferentOwners(tile, diagonal) {
				moves.append(diagonal)
			}
		}
		
		return moves
	}
	
	private static func step(_ tile: Tile, _ state: TileState) -> Tile {
		switch state.owner(tile) {
			case .player: return Tile(row: tile.row-1, column: tile.column)
			case .opponent: return Tile(row: tile.row+1, column: tile.column)
		}
	}
	
	
	private static func doubleStep(_ tile: Tile, _ state: TileState) -> Tile {
		switch state.owner(tile) {
			case .player: return Tile(row: tile.row-2, column: tile.column)
			case .opponent: return Tile(row: tile.row+2, column: tile.column)
		}
	}
	
	private static func diagonals(_ tile: Tile, _ state: TileState) -> [Tile] {
		switch state.owner(tile) {
			case .player: return [Tile(row: tile.row-1, column: tile.column-1),
								  Tile(row: tile.row-1, column: tile.column+1) ]
			case .opponent: return [Tile(row: tile.row+1, column: tile.column-1),
									Tile(row: tile.row+1, column: tile.column+1) ]
		}	}
	
	private static func onOriginalTile(_ tile: Tile, _ state: TileState) -> Bool {
		if state.owner(tile) == .player && tile.row == Chess.pawnRow.player {
			return true
		}
		
		if state.owner(tile) == .opponent && tile.row == Chess.pawnRow.opponent {
			return true
		}
		
		return false
	}
	
}
