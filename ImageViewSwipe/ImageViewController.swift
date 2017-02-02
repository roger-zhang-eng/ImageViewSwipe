//
//  ImageViewController.swift
//  ImageViewSwipe
//
//  Created by Roger Zhang on 2/2/17.
//  Copyright © 2017 Roger.Zhang. All rights reserved.
//

import UIKit

protocol ImageViewProtocol: class {
    func dismissImageView(_ index: Int)
}

class ImageViewController: UIViewController {
    @IBOutlet weak var numButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    var index: Int!
    
    var yOffset: CGFloat!
    var viewHeight: CGFloat!
    
    weak var delegate: ImageViewProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("ImageViewController: viewWillAppear")
        
        self.imageView.image = UIImage(named: "Image\(self.index + 1)")
    }
    
    func viewInit(_ index: Int) {
        self.index = index
    }
    
    func updateViewSize(_ screenWidth: CGFloat) {
        let viewWidth = screenWidth
        //adjust default view frame
        
        let addressListViewframe = CGRectMake(0, yOffset, viewWidth, viewHeight)
        self.view.frame = addressListViewframe
    }
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect
    {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    func removeView() {
        self.willMove(toParentViewController: nil)
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
    
    @IBAction func dimissButtonClicked(_ sender: UIButton) {
        self.removeView()
        self.delegate?.dismissImageView(self.index)
    }

    @IBAction func numButtonClicked(_ sender: UIButton) {
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
