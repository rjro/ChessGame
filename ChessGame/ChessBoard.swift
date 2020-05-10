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
	
	let tileAmount: Int = 8
	var tile: UIView!
		
	//TODO: move this somewhere else
	private func isMoveAllowed(oldTile: Tile, newTile: Tile) -> Bool {
		
		if newTile.row == 3 {
			return true
		}
		
		return false
	}
	
	
	private func commonInit() {
		let tile = Tile(row: 0,column: 0)
		let piece = ChessPiece(tile: tile, view: viewForTile(tile))
		
		addSubview(piece.view)
		piece.view.backgroundColor = .red
		piece.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(dragging(sender:))))
		
	}
	
	
	@objc func dragging(sender: UIPanGestureRecognizer) {
		let pos = sender.location(in: self)
		
		guard let movingPiece = sender.view as? ChessPieceView else {
			return
		}
		
		if sender.state == .ended {
			
			let newTile = tileForPoint(pos)
			var newCenter: CGPoint!
			
			if isMoveAllowed(oldTile: movingPiece.piece!.tile, newTile: newTile) {
				newCenter = centerForTile(newTile)
			} else {
				newCenter = centerForTile(movingPiece.piece!.tile)
			}
			
			UIView.animate(withDuration: 0.1) {
				movingPiece.center = newCenter
			}
			
			
			return
		}
		
		movingPiece.center = pos
		
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}
	

	private func viewForTile(_ tile: Tile) -> ChessPieceView {
		return ChessPieceView(frame: rectForTile(tile))
	}
	
	override func draw(_ rect: CGRect) {
		guard let context = UIGraphicsGetCurrentContext() else {
			return
		}
		
		for tile in tiles {
			switch tile.parity {
			case .even:
				context.setFillColor(UIColor.black.cgColor)
			case .odd:
				context.setFillColor(UIColor.gray.cgColor)
			}
			
			context.fill(rectForTile(tile))
		}
	
		context.setFillColor(UIColor.black.cgColor)
		
	}
	
	
}
