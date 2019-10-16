//
//  tableVC.swift
//  memeMe
//
//  Created by Mohammed Alomari on 2019-10-12.
//  Copyright © 2019 Mohammed Alomari. All rights reserved.
//

import Foundation
import UIKit

class tableVC: UITableViewController
{
    let ID = "displayImageID"

    var memes: [Meme]!
    {
        let object      = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
//        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: self.ID) as! displayImageVC
        VC.meme = self.memes[indexPath.row]
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell                    = tableView.dequeueReusableCell(withIdentifier: "reusableID", for: indexPath) as! tableCell
        cell.cellHeadline.text      = memes[indexPath.row].topComment
        cell.cellImage.image        = memes[indexPath.row].memedImage
        print(memes.count)
        return cell
    }
}

