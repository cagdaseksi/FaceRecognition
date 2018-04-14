//
//  ViewController.swift
//  FaceRecognition
//
//  Created by cagdas on 14/04/2018.
//  Copyright © 2018 cagdas. All rights reserved.
//

import UIKit
import CoreImage

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var lblTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        detect()
    }
    
    @IBAction func btnImage(_ sender: Any) {
        
        //Create image picker
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        //display the image picker
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    //Pick photo
    //func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            myImageView.image = image
        }
        
        detect()
        self.dismiss(animated: true, completion: nil)
    }
    
    func detect()
    {
        //Get image from image view
        let myImage = CIImage(image: myImageView.image!)!
        
        //Set up the detecor
        let accuracy = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy)
        let faces = faceDetector?.features(in: myImage, options: [CIDetectorSmile:true])
        
        if !faces!.isEmpty
        {
            let facesCustom = faces as! [CIFaceFeature]
            
            for face in facesCustom
            {
                let moutShowing = "\n Agiz gozukuyor mu: \(face.hasMouthPosition)"
                let isSmiling = "\n Guluyor mu: \(face.hasSmile)"
                var bothEyesShowing = "\n Her iki goz: acik"
                
                if !face.hasRightEyePosition || !face.hasLeftEyePosition
                {
                    bothEyesShowing = "\n Her iki goz: kapali"
                }
                
                //Degree of suspiciousness
                let array = ["Dusuk", "Orta", "Yuksek", "Cok Yuksek"]
                var suspectDegree = 0
                
                if !face.hasMouthPosition {suspectDegree += 1}
                if !face.hasSmile {suspectDegree += 1}
                if bothEyesShowing.contains("false") {suspectDegree += 1}
                if face.faceAngle > 10 || face.faceAngle < -10 {suspectDegree += 1}
                
                let suspectText = "\n şüphelilik: \(array[suspectDegree])"
                
                lblTextView.text = "\(suspectText) \n\(moutShowing) \(isSmiling) \(bothEyesShowing)"
            }
        }
        else
        {
            lblTextView.text = "Yuz bulunamadi"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

