//
//  ViewController.swift
//  ImageViewSwipe
//
//  Created by Roger Zhang on 2/2/17.
//  Copyright © 2017 Roger.Zhang. All rights reserved.
//

import UIKit

class ImageViewType {
    var index: Int
    var vc: ImageViewController
    var snapImage: UIImage?
    
    init(index: Int, vc: ImageViewController, snapImage: UIImage?) {
        self.index = index
        self.vc = vc
        self.snapImage = snapImage
    }
}

class ViewController: UIViewController, ImageViewProtocol {

    let maxViewNum = 6
    var imageViewArray = [ImageViewType]()
    var currentIndex = 0
    var mainStoryboard: UIStoryboard!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mainStoryboard = UIStoryboard(name: "iPhoneMain", bundle: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonClicked(_ sender: UIButton) {
        if currentIndex < maxViewNum {
            imageViewShow(currentIndex)
            currentIndex = currentIndex + 1
        }
        
    }

    //Choose address widget view functions
    func imageViewSetup(_ index: Int) {
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "ImageDisplayView") as! ImageViewController
        vc.delegate = self
        let imageView = ImageViewType(index: index, vc: vc, snapImage: nil)
        self.imageViewArray.append(imageView)
    }
    
    func imageViewShow(_ index: Int)
    {
        guard (index - self.imageViewArray.count) <= 1 else {
            print("index value \(index) doesn't match with imageViewArray.count \(self.imageViewArray.count)")
            return
        }
        
        if self.imageViewArray.count <= index {
            self.imageViewSetup(index)
        }
        
        let imageViewElement = self.imageViewArray[index]
        
        //init setting for choose address before display
        imageViewElement.vc.viewInit(index)
        
        imageViewElement.vc.yOffset = 0
        imageViewElement.vc.viewHeight = self.view.frame.height
        imageViewElement.vc.updateViewSize(self.view.frame.width)
        imageViewElement.vc.willMove(toParentViewController: self)
        
        self.addBigWidgetView(imageViewElement.vc.view, viewHeight: imageViewElement.vc.viewHeight, animateTime: 0.5, closure: { [weak self] _ in
            self?.addChildViewController(imageViewElement.vc)
            imageViewElement.vc.didMove(toParentViewController: self)
        })
        
    }
    
    private func addBigWidgetView(_ addView: UIView, viewHeight: CGFloat, animateTime: TimeInterval, closure: (()->())?) {
        let addViewFinalFrame = addView.frame
        let addViewInitialFrame = CGRectMake(addViewFinalFrame.origin.x, self.view.frame.height, addViewFinalFrame.width, addViewFinalFrame.height)
        
        addView.frame = addViewInitialFrame
        self.view.addSubview(addView)
        
        UIView.animate(withDuration: animateTime, delay: 0.1, options: .curveEaseIn, animations: {
            addView.frame = addViewFinalFrame
        }, completion: { [weak self] _ in
            
            if closure != nil {
                closure!()
            }
        })
        
        
        self.view.setNeedsDisplay()
        
    }

    func restoreWebViewFromCustomBigWidget(_ index: Int, complete: (() -> Void)?) {
        print("ImageView \(index) is removed!")
        
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveEaseOut, animations: {
            self.view.alpha = 1.0
        }, completion: { [weak self] _ in
            self?.view.setNeedsDisplay()
            //Run complete function
            if complete != nil {
                complete!()
            }
            
        })
    }
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect
    {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    //Mark: - ImageViewProtocol
    func dismissImageView(_ index: Int) {
        self.restoreWebViewFromCustomBigWidget(index, complete: nil)
    }
    
}

