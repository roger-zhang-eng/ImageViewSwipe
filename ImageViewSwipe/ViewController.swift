//
//  ViewController.swift
//  ImageViewSwipe
//
//  Created by Roger Zhang on 2/2/17.
//  Copyright © 2017 Roger.Zhang. All rights reserved.
//

import UIKit

class ImageViewType {
    var tag: Int
    var vc: ImageViewController
    var snapImage: UIImage?
    
    init(tag: Int, vc: ImageViewController, snapImage: UIImage?) {
        self.tag = tag
        self.vc = vc
        self.snapImage = snapImage
    }
}

let maxViewNum = 6

class ViewController: UIViewController, ImageViewProtocol, ItemViewProtocol {
    var imageViewArray = [ImageViewType]()
    var imageViewTagMapping = [Int: Int]() //Tag: Index of imageViewArray
    var mainStoryboard: UIStoryboard!
    var swipVC: SwipViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mainStoryboard = UIStoryboard(name: "iPhoneMain", bundle: nil)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.swipVC == nil {
            self.swipViewSetup()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonClicked(_ sender: UIButton) {
        let tag = sender.tag
        guard tag <= maxViewNum else {
            print("Button tag \(tag) over limitation!")
            return
        }
        
        imageViewShow(tag)

        
    }

    //Choose image view functions
    func seekImageViewByTag(_ tag: Int) -> ImageViewType? {
        guard self.imageViewArray.count > 0 else {
            return nil
        }
        
        for imageView in self.imageViewArray {
            if imageView.tag == tag {
                return imageView
            }
        }
        
        return nil
    }
    
    func imageViewSetup(_ tag: Int) -> ImageViewType {
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "ImageDisplayView") as! ImageViewController
        vc.delegate = self
        let imageView = ImageViewType(tag: tag, vc: vc, snapImage: nil)
        self.imageViewArray.append(imageView)
        self.imageViewTagMapping[tag] = self.imageViewArray.count - 1
        return imageView
    }
    
    func imageViewShow(_ tag: Int)
    {
        
        var imageView = self.seekImageViewByTag(tag)
        
        if imageView == nil {
            imageView = self.imageViewSetup(tag)
        }
        
        //init setting for choose address before display
        imageView!.vc.viewInit(tag)
        
        imageView!.vc.yOffset = 0
        imageView!.vc.viewHeight = self.view.frame.height
        imageView!.vc.updateViewSize(self.view.frame.width)
        imageView!.vc.willMove(toParentViewController: self)
        
        self.addBigWidgetView(imageView!.vc.view, viewHeight: imageView!.vc.viewHeight, animateTime: 0.5, closure: { [weak self] _ in
            self?.addChildViewController(imageView!.vc)
            imageView!.vc.didMove(toParentViewController: self)
        })
        
    }
    
    private func addBigWidgetView(_ addView: UIView, viewHeight: CGFloat, animateTime: TimeInterval, closure: (()->())?) {
        let addViewFinalFrame = addView.frame
        let addViewInitialFrame = CGRectMake(addViewFinalFrame.origin.x, self.view.frame.height, addViewFinalFrame.width, addViewFinalFrame.height)
        
        addView.frame = addViewInitialFrame
        self.view.addSubview(addView)
        self.view.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: animateTime, delay: 0.1, options: .curveEaseIn, animations: {
            addView.frame = addViewFinalFrame
        }, completion: { [weak self] _ in
            
            if closure != nil {
                closure!()
            }
            self?.view.isUserInteractionEnabled = true
        })
        
        
        self.view.setNeedsDisplay()
        
    }

    func queueWebViewFromCustomBigWidget(_ index: Int, complete: (() -> Void)?) {
        print("ImageView \(index) will be removed!")
        let imageView = imageViewArray[index]
        //let initFrame = imageView.vc.view.frame
        let finalFrame = self.webSnapshotFinalFrame() //CGRectMake(initFrame.origin.x, self.view.frame.height, initFrame.width, initFrame.height)
        self.view.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveEaseOut, animations: {
            imageView.vc.view.frame = finalFrame
        }, completion: { [weak self] _ in
            self?.view.setNeedsDisplay()
            //Run complete function
            if complete != nil {
                complete!()
            }
            self?.view.isUserInteractionEnabled = true
        })
    }
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect
    {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    //Mark: - ImageViewProtocol
    func dismissImageView(_ tag: Int, snapshot: UIImage?) {
        
        guard let imageView = self.seekImageViewByTag(tag) else {
            return
        }
        
        imageView.snapImage = snapshot
        
        self.queueWebViewFromCustomBigWidget(self.imageViewTagMapping[tag]!, complete: { [weak self] _ in
            imageView.vc.removeView()
            if self?.swipVC != nil {
                self?.addSwipView()
                let snapShot = snapShotType(image: imageView.snapImage!, tag: tag)
                
                self?.swipVC!.updateSnapshots(snapShot)
                //self?.swipVC!.restoreSwipeViewPosition()
                self?.swipVC!.swipView.resetScrollContentOffset()
                self?.swipVC!.swipView.reloadData()
            }
        })
    }
    
    func webSnapshotFinalFrame() -> CGRect {
        var finalFrame: CGRect!
        let snapViewHeight: CGFloat = 180
        let snapViewWidth: CGFloat = 120
        let imageHInset: CGFloat = 10
        let imageVInset: CGFloat = 5
        let yOffset: CGFloat = self.view.frame.height - 20 - snapViewHeight
        
        if self.swipVC == nil {
            //web snapshot scroll view is created 1st time, and item is only 1.
            let xOffset: CGFloat = self.view.frame.width - snapViewWidth
            finalFrame = CGRectMake(xOffset + imageHInset, yOffset - imageVInset, (snapViewWidth - 2 * imageHInset), (snapViewHeight - 2 * imageVInset))
        } else {
            //web snapshot scroll view items are more than 1.
            let xOffset: CGFloat = self.view.frame.width - snapViewWidth * 1.3
            finalFrame = CGRectMake(xOffset + imageHInset, yOffset - imageVInset, (snapViewWidth - 2 * imageHInset), (snapViewHeight - 2 * imageVInset))
        }
        
        return finalFrame
    }
    
    //swipVie functions
    func swipViewSetup() {
        self.swipVC = SwipViewController(nibName: "ImageQueueView", bundle: nil)
        self.swipVC!.itemViewSwipActRef = self
        self.swipVC!.viewDidLoad()

        let swipViewHeight: CGFloat = 180
        let yOffset: CGFloat = self.view.frame.height - 20 - swipViewHeight
        self.swipVC!.swipView.frame = CGRectMake(0, yOffset, self.view.frame.width, swipViewHeight)

    }
    
    func addSwipView() {
        guard self.swipVC != nil && !self.swipVC!.viewAdded else {
            return
        }
        
        self.view.addSubview(self.swipVC!.swipView)
        self.swipVC!.viewAdded = true
    }
    
    //Mark: - ItemViewProtocol
    func swipUpAction(_ tag: Int) {
        let index = self.imageViewTagMapping[tag]!
        print("In ViewController: ItemView index \(index) swip up")
        self.imageViewShow(tag)
    }
    
}

