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
	
	var state = [[UIView?]]()

	
	private func commonInit() {
		state = [[UIView?]](repeating: [UIView?](repeating: nil, count: board.size.columns), count: board.size.rows)

		
		Chess.setupBoard(board)
		
		for (piece, tile) in board.occupations() {
			let pieceView = UIView(frame: rectForTile(tile))
					
			let pieceImageView = UIImageView(frame: CGRect(origin: .zero, size: pieceView.frame.size))
			pieceImageView.image = UIImage(named: "\(piece.color)_\(piece.rank)")
			pieceView.addSubview(pieceImageView)
			
			pieceView.layer.zPosition = 5
			
			state[tile.row][tile.column] = pieceView
			

		
			let gr = UIPanGestureRecognizer(target: self, action: #selector(dragView(sender:)))
			pieceView.addGestureRecognizer(gr)
			gr.delegate = self
			

			addSubview(pieceView)
		}
		
		
		/*
		DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
			self.capturePiece(tile: Tile(row: 0, column: 0))
		}*/
		
		
	}
	
	//should this be called "move view?"
	//dislike this whole "state" solution but
	//we need some reference to do animation so
	//this seems OK for now
	func movePiece(oldTile: Tile, newTile: Tile) {
		
		UIView.animate(withDuration: 0.3) {
			self.state[oldTile.row][oldTile.column]!.center = self.state[newTile.row][newTile.column]!.center
		}
		
	}
	
	func capturePiece(tile: Tile) {
		
		state[tile.row][tile.column]?.removeFromSuperview()
		
	}
	
	
	func highlightTiles(_ tiles: [Tile]) {
		
		for tile in tiles {
			let rect = rectForTile(tile)
			let tileView = UIView(frame: rect)
			
			tileView.backgroundColor = UIColor(red: 205/255, green: 210/255, blue: 106/255, alpha: 1)
			
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
			
			var pieceDestination: CGPoint!
			
			//return valid, invalid, capture
			//if capture, we have to fade out the piece!!!
			
			let (validMove, capture) = board.isValidMove(oldTile: dragStartTile!, newTile: newTile)
			
	
			if validMove {
				
				if capture { self.capturePiece(tile: newTile) }
				
				pieceDestination = centerForTile(newTile)
				board.movePiece(oldTile: dragStartTile!, newTile: newTile)
				print("MOVED FROM:", dragStartTile!, "TO:", newTile)
			} else {
				print("how to return to original location??")
				pieceDestination = centerForTile(dragStartTile!)
			}
						
			UIView.animate(withDuration: 0.1, animations: {
				pieceView.center = pieceDestination
			}) { _ in
				SoundPlayer.shared.playBonk()

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
		
		let evenColor = UIColor(red: 240/255, green: 217/255, blue: 181/255, alpha: 1).cgColor
		let oddColor = UIColor(red: 181/255, green: 136/255, blue: 99/255, alpha: 1).cgColor
		
		for tile in tiles {
			if (tile.row+tile.column).isMultiple(of: 2)  {
				context.setFillColor(evenColor)
				
			} else {
				context.setFillColor(oddColor)
			}
			
			
			context.fill(rectForTile(tile))
		}
		
		context.setFillColor(UIColor.black.cgColor)
		
	}
	
	
}
