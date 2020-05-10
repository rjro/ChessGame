//
//  ChessBoard.swift
//  ChessGame
//
//  Created by Roger J. Romero on 5/9/20.
//  Copyright © 2020 Roger J. Romero. All rights reserved.
//

import Foundation
import UIKit



class ChessBoardView: UIView, Tiler, UIGestureRecognizerDelegate {
	
	let board = Board(size: (8,8))
	
	
	let tileAmount = 8
	
	var tileHighlighters = [UIView]()
	
	
	private func commonInit() {
		
		
		//for tile in board.bishopMoves(tile: Tile(row: 5, column: 2)) {
		//	board.state[tile.row][tile.column] = Piece(rank: .bishop)
		//}
		
		board.homeSetup()
		for (piece, tile) in board.occupations() {
			let pieceView = UIView(frame: rectForTile(tile))
			//pieceView.alpha = 0.3
			
			switch piece.rank {
			case .pawn: pieceView.backgroundColor = .blue
			case .knight: pieceView.backgroundColor = .green
			case .rook: pieceView.backgroundColor = .yellow
			case .bishop: pieceView.backgroundColor = .purple
			case .queen: pieceView.backgroundColor = .cyan
			case .king: pieceView.backgroundColor = .red
			}
			
			pieceView.layer.cornerRadius = 40.0
			pieceView.layer.zPosition = 2
			pieceView.center = centerForTile(tile)
			
			
			let gr = UIPanGestureRecognizer(target: self, action: #selector(dragView(sender:)))
			pieceView.addGestureRecognizer(gr)
			gr.delegate = self
			
			
			addSubview(pieceView)
		}
		
		
	}
	
	
	func highlightTiles(_ tiles: [Tile]) {
		
		for tile in tiles {
			let rect = rectForTile(tile)
			let tileView = UIView(frame: rect)
			tileView.backgroundColor = .orange
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
	
	
	//have to add this delegate methods cause GR points are off
	//https://stackoverflow.com/questions/2861400/uipangesturerecognizer-starting-point-is-off
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
		let point = touch.location(in: self)
		let curTile = tileForPoint(point)
		dragStartTile = curTile
		let possibleMoves = board.possibleMoves(tile: curTile)
		highlightTiles(possibleMoves)
		return true
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		removeAllHighlights()
	}
	
	
	@objc func dragView(sender: UIPanGestureRecognizer) {
		let point = sender.location(in: self)
		
		guard let pieceView = sender.view else {
			return
		}
		
		
		if sender.state == .ended {
			removeAllHighlights()
			
			let newTile = tileForPoint(point)
			
			if board.isValidMove(oldTile: dragStartTile!, newTile: newTile) {
				pieceView.center = centerForTile(newTile)
				board.movePiece(oldTile: dragStartTile!, newTile: newTile)
				print("MOVED FROM:", dragStartTile!, "TO:", newTile)
			} else {
				print("how to return to original location??")
				pieceView.center = centerForTile(dragStartTile!)
			}
			
			dragStartTile = nil
			
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
				context.setFillColor(UIColor.white.cgColor)
			}
			
			context.fill(rectForTile(tile))
		}
		
		context.setFillColor(UIColor.black.cgColor)
		
	}
	
	
}
