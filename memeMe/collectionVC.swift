//
//  collectionVC.swift
//  memeMe
//
//  Created by Mohammed Alomari on 2019-10-14.
//  Copyright © 2019 Mohammed Alomari. All rights reserved.
//

import Foundation
import UIKit

class collectionVC: UICollectionViewController {
    
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
        navigationController?.hidesBarsOnSwipe = false
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 0,left: 5,bottom: 0,right: 5)
        layout.minimumInteritemSpacing = 5
        
        collectionView.setContentOffset(collectionView.contentOffset, animated:false)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = false
        self.collectionView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnSwipe = false
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.memes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width/2, height: self.view.frame.width/2)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: self.ID) as! displayImageVC
        VC.meme = self.memes[indexPath.row]
        self.navigationController?.pushViewController(VC, animated: true)
    }

    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reusableID", for: indexPath) as! CollectionCell
        
        cell.memedImage.image = self.memes[indexPath.row].memedImage
//        cell.memedImage.image = UIImage(named: "LaunchImage")
        
        return cell
    }
}
