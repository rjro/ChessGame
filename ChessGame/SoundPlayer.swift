//
//  SoundPlayer.swift
//  ChessGame
//
//  Created by Roger J. Romero on 5/10/20.
//  Copyright © 2020 Roger J. Romero. All rights reserved.
//

import Foundation
import AVFoundation

class SoundPlayer {
	
	static let shared = SoundPlayer()
	
	let bonk: AVAudioPlayer
	
	init() {
		let path = Bundle.main.path(forResource: "bonk", ofType: "wav")
		let url = NSURL.fileURL(withPath: path!)
		self.bonk = try! AVAudioPlayer(contentsOf: url)

	}
	
	func playBonk() {
		bonk.play()
	}

}
