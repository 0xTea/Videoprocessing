//
//  ViewController.swift
//  VideoProcessingtest
//
//  Created by Tshepo on 2016/11/18.
//  Copyright © 2016 test. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var imageview: UIImageView!
    var videoCameraWrapper : OpenCVWrapper!
        var myCamera : CvVideoCamera!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.videoCameraWrapper = OpenCVWrapper(controller:self, andImageView:imageview)
        reloadInputViews()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

