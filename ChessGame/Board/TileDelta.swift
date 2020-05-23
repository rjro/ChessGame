//
//  Move.swift
//  ChessGame
//
//  Created by Roger J. Romero on 5/23/20.
//  Copyright © 2020 Roger J. Romero. All rights reserved.
//

import Foundation

protocol TileDelta {
	var oldTile: Tile { get }
	var newTile: Tile { get }
}
