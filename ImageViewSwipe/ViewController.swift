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
    var tag: Int
    var vc: ImageViewController
    var snapImage: UIImage?
    
    init(index: Int, tag: Int, vc: ImageViewController, snapImage: UIImage?) {
        self.index = index
        self.tag = tag
        self.vc = vc
        self.snapImage = snapImage
    }
}

class ViewController: UIViewController, ImageViewProtocol {

    let maxViewNum = 6
    var imageViewArray = [ImageViewType]()
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
        let tag = sender.tag
        guard tag < maxViewNum else {
            print("Button tag \(tag) over limitation!")
            return
        }
        
        imageViewShow((tag - 1), tag: tag)

        
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
    
    func imageViewSetup(_ index: Int, tag: Int) -> ImageViewType {
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "ImageDisplayView") as! ImageViewController
        vc.delegate = self
        let imageView = ImageViewType(index: index, tag: tag, vc: vc, snapImage: nil)
        self.imageViewArray.append(imageView)
        
        return imageView
    }
    
    func imageViewShow(_ index: Int, tag: Int)
    {
        
        var imageView = self.seekImageViewByTag(tag)
        
        if imageView == nil {
            imageView = self.imageViewSetup(index, tag: tag)
        }
        
        //init setting for choose address before display
        imageView!.vc.viewInit(index, tag: tag)
        
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
        print("ImageView \(index) will be removed!")
        let imageView = imageViewArray[index]
        let initFrame = imageView.vc.view.frame
        let finalFrame = CGRectMake(initFrame.origin.x, self.view.frame.height, initFrame.width, initFrame.height)
        
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveEaseOut, animations: {
            imageView.vc.view.frame = finalFrame
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
        self.restoreWebViewFromCustomBigWidget(index, complete: { [weak self] _ in
            let imageView = self?.imageViewArray[index]
            imageView?.vc.removeView()
        })
    }
    
}

