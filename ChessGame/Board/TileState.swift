//
//  TileState.swift
//  ChessGame
//
//  Created by Roger J. Romero on 5/18/20.
//  Copyright © 2020 Roger J. Romero. All rights reserved.
//

import Foundation

protocol TileState {
	func exists(_ tile: Tile) -> Bool
	func isOccupied(_ tile: Tile) -> Bool
	func haveDifferentOwners(_ a: Tile, _ b: Tile) -> Bool
}
