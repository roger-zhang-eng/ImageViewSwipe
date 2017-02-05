//
//  ItemView.swift
//  ImageViewSwipe
//
//  Created by Roger Zhang on 3/2/17.
//  Copyright © 2017 Roger.Zhang. All rights reserved.
//

import UIKit

protocol ItemViewProtocol: class {
    func swipUpAction(_ tag: Int)
}

class ItemView: UIView {

    @IBOutlet weak var imageView: UIImageView!
    var tagForItem: Int?
    weak var delegate: ItemViewProtocol?

    func setSwipUpAction(_ ref: ViewController)  {
        self.delegate = ref
        let swipeUp = UISwipeGestureRecognizer(target: self, action:  #selector(ItemView.respondToSwipeUpGesture(_:)))
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        self.addGestureRecognizer(swipeUp)
    }
    
    func respondToSwipeUpGesture(_ sender: UISwipeGestureRecognizer) {
            let swipeGesture = sender
            
            switch swipeGesture.direction {
                
            case UISwipeGestureRecognizerDirection.up:
                
                print("In ItemView: Index \(self.tagForItem!) View up, frame \(self.frame).")
                self.delegate?.swipUpAction(self.tagForItem!)
                
            default:
                break
            }
        
    }

}
