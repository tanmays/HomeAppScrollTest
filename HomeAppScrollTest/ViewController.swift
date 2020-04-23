//
//  ViewController.swift
//  HomeAppScrollTest
//
//  Created by Tanmay on 23/04/20.
//  Copyright © 2020 Tanmay. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	@IBOutlet weak var scrollView: UIScrollView!
	
	@IBOutlet weak var aboveFoldView: UIView!
	@IBOutlet weak var belowFoldView: UIView!
	
	let pageThresholdPercent: CGFloat = 20
	
	var isTriggered = false

	override func viewDidLoad() {
		super.viewDidLoad()
		
		scrollView.delegate = self
	}
	
	@IBAction func resetTriggerTapped(_ sender: Any) {
		UIView.animate(withDuration: 0.25, animations: {
			self.scrollView.contentOffset = .zero
		}) { (done) in
			self.isTriggered = false
		}
	}
}

extension ViewController: UIScrollViewDelegate {
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		guard !isTriggered else { return }
		
		if isThresholdCrossed() {
			print("Trigger it")
			let targetOffset = CGPoint(x: scrollView.contentOffset.x, y: belowFoldView.frame.minY)
			scrollView.setContentOffset(targetOffset, animated: true)
			let impact = UIImpactFeedbackGenerator()
			impact.impactOccurred()
			isTriggered = true
			scrollView.isScrollEnabled = false
			
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
				scrollView.isScrollEnabled = true
			}
		}
	}
	
	func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		guard !isTriggered else { return }
		
		if !isThresholdCrossed() {
			scrollView.setContentOffset(.zero, animated: true)
		}
	}
	
	func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
		guard !isTriggered else { return }
		
		if !isThresholdCrossed() {
			scrollView.setContentOffset(.zero, animated: true)
		}
	}
	
	private func isThresholdCrossed() -> Bool {
		if scrollView.contentOffset.y > (aboveFoldView.bounds.height * pageThresholdPercent) / 100 {
			return true
		}
		
		return false
	}
}
