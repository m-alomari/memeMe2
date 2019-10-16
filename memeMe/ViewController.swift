//
//  ViewController.swift
//  memeMe
//
//  Created by Mohammed Alomari on 2019-09-19.
//  Copyright © 2019 Mohammed Alomari. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate
{
    let imagePickerController = UIImagePickerController()
    let sourceType: SOURCETYPES = SOURCETYPES()
    let placeholder: PLACEHOLDERS = PLACEHOLDERS()

    // Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topComment: UITextField!
    @IBOutlet weak var bottomComment: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var takePhoto: UIBarButtonItem!
    @IBOutlet weak var actionToolBar: UIToolbar!
    @IBOutlet weak var optionsToolBar: UIToolbar!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        print(debugger[0] ?? nil!)
        self._configurations(comment: topComment, defaultText: placeholder.TOP)
        self._configurations(comment: bottomComment, defaultText: placeholder.BOTTOM)
        self._toggleToManage()
        if !UIImagePickerController.isSourceTypeAvailable(.camera)
        {
            takePhoto.isEnabled = false
            print(debugger[4] ?? nil!)
            
        }
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // Actions
    @IBAction func pickAnImageFromAlbum(_ sender: Any)
    {
        print(debugger[5] ?? nil!)
        _init(sourceSelected: sourceType.PHOTO_LIBRARY)
        _present(vc: imagePickerController)
    }
    
    @IBAction func takePhoto(_ sender: Any)
    {
        print(debugger[6] ?? nil!)
        _init(sourceSelected: sourceType.CAMERA)
        _present(vc: imagePickerController)
    }
    
    @IBAction func share(_ sender: Any)
    {
        self._toggleToSave()
        
        let meme = Meme(topComment: topComment.text!, bottomComment: bottomComment.text!, originalImage: imageView.image!, memedImage: generateMemedImage())
        let activityViewController = UIActivityViewController(activityItems: [meme.memedImage] , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if !completed
            {
                print(debugger[20] ?? nil!)
                return
            }
            else
            {
                self.save()
            }
            
        }

        self.present(activityViewController, animated: true, completion: nil)
        self.imagePickerController.dismiss(animated: true, completion: nil)
        self._toggleToSave()
    }
    
    @IBAction func cancelButton(_ sender: Any)
    {
        print(debugger[19] ?? nil!)
        imageView.image = nil
        shareButton.isEnabled = !shareButton.isEnabled
        cancelButton.isEnabled = !cancelButton.isEnabled
        topComment.text = placeholder.TOP
        bottomComment.text = placeholder.BOTTOM
        print(debugger[22] ?? nil!)
    }
    
    
    // delegations
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imageView.image = image
        picker.dismiss(animated: true, completion: nil)
        if !shareButton.isEnabled
        {
            self._toggleToManage()
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) -> Void
    {
        textField.text = placeholder.RESET
        print(debugger[15] ?? nil!)
    }
        

    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        print(debugger[16] ?? nil!)
        textField.resignFirstResponder()
        return true
    }
    
    
    
    //@Objc
    @objc func keyboardWillShow(_ notification:Notification)
    {
        if self.view.frame.origin.y == 0 && bottomComment.isEditing
        {
            print(debugger[17] ?? nil!)
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification)
    {
        if self.view.frame.origin.y != 0
        {
            print(debugger[18] ?? nil!)
            self.view.frame.origin.y = 0
        }
    }
    
    // helpers
    func _configurations(comment: UITextField, defaultText: String) -> Void
    {
        print(debugger[1] ?? nil!)
        comment.delegate = self
        comment.defaultTextAttributes = self._getNSAttributedString()
        self._textFieldPrettifier(textField: comment, defaultText: defaultText)
    }
    
    private func save () -> Void
    {
        let meme = Meme(topComment: topComment.text!, bottomComment: bottomComment.text!, originalImage: imageView.image!, memedImage: generateMemedImage())
        let object      = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        
        appDelegate.memes.append(meme)
        print(debugger[21] ?? nil!)
        self.imagePickerController.dismiss(animated: true, completion: nil)
    }
    
    private func _getNSAttributedString() -> [NSAttributedString.Key: Any]
    {
        return
            [
                NSAttributedString.Key.strokeColor: UIColor.black,
                NSAttributedString.Key.foregroundColor: UIColor.white,
                NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 35)!,
                NSAttributedString.Key.strokeWidth: -3.6
            ]
    }
    
    private func _textFieldPrettifier(textField: UITextField, defaultText: String) -> Void
    {
        textField.textAlignment     = .center
        textField.text              = defaultText
        textField.textColor         = UIColor.white
        textField.backgroundColor   = UIColor.clear
    }
    
    func _init(sourceSelected: String) -> Void
    {
        print(debugger[8] ?? nil!)
        imagePickerController.delegate = self
        switch sourceSelected {
            case sourceType.PHOTO_LIBRARY:
                guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
                else
                {
                    print(debugger[9] ?? nil!)
                    return
                }
                imagePickerController.sourceType = .photoLibrary
                print(debugger[5] ?? nil!)
                return
            
            case sourceType.CAMERA:
                guard UIImagePickerController.isSourceTypeAvailable(.camera)
                else
                {
                    takePhoto.isEnabled = false
                    print(debugger[10] ?? nil!)
                    
                    return
                }
                takePhoto.isEnabled = true
                imagePickerController.sourceType = .camera
                print(debugger[6] ?? nil!)
                return
            
            case sourceType.SAVED_PHOTO_ALBUM:
                guard UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum)
                else
                {
                    print(debugger[11] ?? nil!)
                    return
                }
                imagePickerController.sourceType = .savedPhotosAlbum
                print(debugger[12] ?? nil!)
                return
            
            default:
                print(debugger[13] ?? nil!)
                return
        }
    }
    
    func _present(vc: UIImagePickerController) -> Void
    {
        present(vc, animated: true, completion: nil)
        print(debugger[14] ?? nil!)
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat
    {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    private func _toggleToManage() -> Void
    {
        print(debugger[2] ?? nil!)
        shareButton.isEnabled = !shareButton.isEnabled
        cancelButton.isEnabled = !cancelButton.isEnabled
    }
    
    private func _toggleToSave() -> Void
    {
        print(debugger[3] ?? nil!)
        actionToolBar.isHidden = !actionToolBar.isHidden
        optionsToolBar.isHidden = !optionsToolBar.isHidden
    }
    
    // exportion
    func generateMemedImage() -> UIImage
    {
        print(debugger[7] ?? nil!)
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return memedImage
    }
}


// data-structures
struct SOURCETYPES
{
    let CAMERA: String = "camera"
    let PHOTO_LIBRARY: String = "photoLibrary"
    let SAVED_PHOTO_ALBUM: String = "savedPhotosAlbum"
}

struct PLACEHOLDERS {
    let TOP     : String = "TOP"
    let BOTTOM  : String = "BOTTOM"
    let RESET   : String = ""
}

struct Meme
{
    var topComment      : String
    var bottomComment   : String
    var originalImage   : UIImage
    var memedImage      : UIImage
}

