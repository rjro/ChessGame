//
//  ViewController.swift
//  ChessGame
//
//  Created by Roger J. Romero on 5/9/20.
//  Copyright © 2020 Roger J. Romero. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
		view.backgroundColor = .darkGray
        let chessBoard = ChessBoardView(frame: CGRect(origin: .zero, size: CGSize(width: 400, height: 400)))
        chessBoard.center = self.view.center
        chessBoard.backgroundColor = UIColor.red
       // chessBoard.highlightTile(row: 3, column: 3)
        view.addSubview(chessBoard)
        
        
    }


}

