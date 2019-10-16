//
//  displayImageVC.swift
//  memeMe
//
//  Created by Mohammed Alomari on 2019-10-16.
//  Copyright © 2019 Mohammed Alomari. All rights reserved.
//

import Foundation
import UIKit

class displayImageVC: UIViewController
{
    var meme: Meme!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = meme.memedImage
    }
}
