//
//  SwipViewController.swift
//  ImageViewSwipe
//
//  Created by Roger Zhang on 3/2/17.
//  Copyright © 2017 Roger.Zhang. All rights reserved.
//

import UIKit

struct snapShotType {
    var image: UIImage
    let tag: Int
}

class SwipViewController: UIViewController, SwipeViewDelegate, SwipeViewDataSource {

    @IBOutlet var swipView: SwipeView!
    var snapShotArray = [snapShotType]()
    var itemViewSwipActRef: ViewController!
    var viewAdded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("viewDidLoad in SwipViewController.")
        
        /*for _ in 1...maxViewNum {
            self.snapShotArray.append(UIImage(named: "shoppingIcon")!)
        }
        */
        
        Bundle.main.loadNibNamed("ImageQueueView", owner: self, options: nil)
        
        swipView.delegate = self
        swipView.dataSource = self
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateSnapshots(_ snapshot: snapShotType) {
        for (index, item) in self.snapShotArray.enumerated() {
            if item.tag == snapshot.tag {
                snapShotArray[index].image = snapshot.image
                return
            }
        }
        
        self.snapShotArray.append(snapshot)
    }
    
    //This func is never be called by system
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("viewWillAppear in SwipViewController.")
        self.swipView.backgroundColor = UIColor.blue
    }

    func numberOfItems(in swipeView: SwipeView!) -> Int {
        return snapShotArray.count //maxViewNum
    }
    

    
    func swipeView(_ swipeView: SwipeView!, viewForItemAt index: Int, reusing view: UIView!) -> UIView! {
        var itemView: ItemView!
        if view == nil {
            itemView = Bundle.main.loadNibNamed("ItemView", owner: self, options: nil)?.first as! ItemView
            itemView.setSwipUpAction(self.itemViewSwipActRef)
        
        } else {
            itemView = view as! ItemView
        }
        
        let displayIndex = self.snapShotArray.count - 1 - index
        
        itemView.imageView.image = self.snapShotArray[displayIndex].image
        itemView.tagForItem = self.snapShotArray[displayIndex].tag
        
        return itemView!
    }

}
