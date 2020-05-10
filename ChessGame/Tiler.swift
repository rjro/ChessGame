//
//  Tiler.swift
//  ChessGame
//
//  Created by Roger J. Romero on 5/9/20.
//  Copyright © 2020 Roger J. Romero. All rights reserved.
//

import Foundation
import UIKit

protocol Tiler {
	var frame: CGRect { get }
	var tileAmount: Int { get }
}

extension Tiler {
	var tileSize: CGFloat { frame.width / CGFloat(tileAmount) }
	
	var tiles: [Tile] {
		(0 ..< tileAmount).map { row -> [Tile] in
			(0 ..< tileAmount).map { column -> Tile in
				Tile(row: row, column: column)
			}
		}.flatMap { $0 }
	}

	func tileForPoint(_ point: CGPoint) -> Tile {
		//subtract one to become zero-indexed
		let tileColumn = Int(floor(point.x/tileSize))
		let tileRow = Int(floor(point.y/tileSize))
		
		print(tileRow, tileColumn, tileSize)
		
		return Tile(row: tileRow, column: tileColumn)
	}
	
	
	func rectForTile(_ tile: Tile) -> CGRect {
		CGRect(
			x: tileSize * CGFloat(tile.column),
			y: tileSize * CGFloat(tile.row),
			width: tileSize,
			height: tileSize
		)
	}
	
	func centerForTile(_ tile: Tile) -> CGPoint { rectForTile(tile).center }
}
