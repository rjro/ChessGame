//
//  ChessBoard.swift
//  ChessGame
//
//  Created by Roger J. Romero on 5/9/20.
//  Copyright © 2020 Roger J. Romero. All rights reserved.
//

import Foundation
import UIKit



class ChessBoardView: UIView, Tiler {
	
	
	let board = Board(size: (8,8))
	
	
	let tileAmount = 8
	
	var tileHighlighters = [UIView]()
		
	//TODO: move this somewhere else
	private func isMoveAllowed(oldTile: Tile, newTile: Tile) -> Bool {
		
		if newTile.row == 3 {
			return true
		}
		
		return true
	}
	
	
	private func commonInit() {

				
		for tile in board.bishopMoves(tile: Tile(row: 5, column: 2)) {
			board.state[tile.row][tile.column] = Piece(rank: .bishop)
		}
	
		
		for (piece, tile) in board.occupations() {
			let pieceView = UIView(frame: rectForTile(tile))
			//pieceView.alpha = 0.3
			pieceView.backgroundColor = .red
			pieceView.layer.cornerRadius = 30.0
			pieceView.layer.zPosition = 2
			pieceView.center = centerForTile(tile)
			pieceView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(dragView(sender:))))

			addSubview(pieceView)
		}

				
	}
	
	
	func highlightTiles(_ tiles: [Tile]) {
		
		for tile in tiles {
			let rect = rectForTile(tile)
			let tileView = UIView(frame: rect)
			tileView.backgroundColor = .yellow
			tileView.alpha = 0.5
			tileView.layer.zPosition = 1
			tileHighlighters.append(tileView)
			addSubview(tileView)
		}
		
	}
	
	private func removeAllHighlights() {
		tileHighlighters.forEach { $0.removeFromSuperview() }
		tileHighlighters.removeAll()
	}
		
	//gotta come up with a better solution than this
	var dragStartTile: Tile?
	
	@objc func dragView(sender: UIPanGestureRecognizer) {
		let point = sender.location(in: self)
		
		if sender.state == .began {
			let curTile = tileForPoint(point)
			dragStartTile = curTile
			let possibleMoves = board.possibleMoves(tile: curTile)
			//print("diag:", curTile, possibleMoves, board.state, board.state[curTile.row][curTile.column])
			highlightTiles(possibleMoves)
		}
		
		
		guard let pieceView = sender.view else {
			return
		}
		

		
		if sender.state == .ended {
			removeAllHighlights()
			
			
			let newTile = tileForPoint(point)
			
			if board.isValidMove(oldTile: dragStartTile!, newTile: newTile) {
				pieceView.center = centerForTile(newTile)
				board.movePiece(oldTile: dragStartTile!, newTile: newTile)
			} else {
				pieceView.center = centerForTile(dragStartTile!)
			}
			

			return

		}

		

		pieceView.center = point
		
	}

	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}

	
	override func draw(_ rect: CGRect) {
		guard let context = UIGraphicsGetCurrentContext() else {
			return
		}
		
		for tile in tiles {
			if (tile.row+tile.column).isMultiple(of: 2)  {
				context.setFillColor(UIColor.black.cgColor)

			} else {
				context.setFillColor(UIColor.gray.cgColor)
			}
			
			context.fill(rectForTile(tile))
		}
	
		context.setFillColor(UIColor.black.cgColor)
		
	}
	
	
}
