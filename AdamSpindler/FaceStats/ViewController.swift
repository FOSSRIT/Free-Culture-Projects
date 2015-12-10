//
//  ViewController.swift
//  FaceStats
//
//  Created by Adam Spindler on 11/28/15.
//  Copyright © 2015 Adam Spindler. All rights reserved.
//

import UIKit
import CoreImage

class FacialFeatures
{
    var eyeSeparation: Double!
    var leftEyeToMouth: Double!
    var rightEyeToMouth: Double!
    var faceWidth: Double!
    var faceHeight: Double!
    
    // 0 = female, 1 = male
    var gender: Double!
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onDoWork(sender: AnyObject) {
        let maleFaces: [String] = [
            "https://i.imgur.com/O94qvsP.jpg",
            "https://i.imgur.com/S4JyCVG.jpg",
            "https://i.imgur.com/FomkPF2.jpg",
            "https://i.imgur.com/yWCrHK7.jpg",
            "https://i.imgur.com/ZBHeOPO.jpg",
            "https://i.imgur.com/15d2253.jpg",
            "https://i.imgur.com/V2xAfJ1.jpg",
            "https://i.imgur.com/jZZDJz6.jpg",
            "https://i.imgur.com/rPWVlhn.jpg",
            "https://i.imgur.com/T5P5zWZ.jpg",
            "https://i.imgur.com/8wDjP0V.jpg",
            "https://i.imgur.com/bdAQKOt.jpg",
            "https://i.imgur.com/NxWKLe5.jpg",
            "https://i.imgur.com/QHBzLbj.jpg",
            "https://i.imgur.com/EFrlCMb.jpg",
            "https://i.imgur.com/1LsvzYt.jpg",
            "https://i.imgur.com/5ecuoQO.jpg",
            "https://i.imgur.com/OaSttxo.jpg",
            "https://i.imgur.com/8KfWp0H.jpg",
            "https://i.imgur.com/6VYJKw9.jpg",
            "https://i.imgur.com/h1H9vOV.png",
            "https://i.imgur.com/Geuhtnp.jpg",
            "https://i.imgur.com/DELaENh.jpg",
            "https://i.imgur.com/yGYgUW0.jpg",
            "https://i.imgur.com/wuk6sKq.jpg",
            "https://i.imgur.com/CrUJrkj.jpg",
            "https://i.imgur.com/pxEOr0I.jpg",
            "https://i.imgur.com/ulipoe5.jpg",
            "https://i.imgur.com/lDiEFQ5.jpg",
            "https://i.imgur.com/YWlkMly.jpg",
            "https://i.imgur.com/CL2NMny.jpg",
            "https://i.imgur.com/UKUCoKi.jpg",
            "https://i.imgur.com/fpHdmG6.jpg",
            "https://i.imgur.com/pnoIuhc.jpg",
            "https://i.imgur.com/Xo2tdsw.jpg",
            "https://i.imgur.com/1lAr83P.jpg",
            "https://i.imgur.com/v9SP4sN.jpg",
            "https://i.imgur.com/GJzT9Wg.jpg",
            "https://i.imgur.com/zCkj4vB.jpg",
            "https://i.imgur.com/UMrF2pD.jpg",
            "https://i.imgur.com/oH36caE.jpg",
            "https://i.imgur.com/jZT0MQE.jpg",
            "https://i.imgur.com/GbxPmYC.jpg",
            "https://i.imgur.com/gT8Jjow.jpg",
            "https://i.imgur.com/9zNZXcx.jpg",
            "https://i.imgur.com/XNDxLOP.jpg",
            "https://i.imgur.com/gPc3qSX.jpg",
            "https://i.imgur.com/kkyj0W6.jpg",
            "https://i.imgur.com/8hxaRwP.jpg",
            "https://i.imgur.com/K3uT0Ot.jpg"
        ]
        
        let femaleFaces: [String] = [
            "https://i.imgur.com/lKmnse6.jpg",
            "https://i.imgur.com/TWlCDqx.jpg",
            "https://i.imgur.com/EuMDjyS.jpg",
            "https://i.imgur.com/fZQqpKR.png",
            "https://i.imgur.com/ZzsRjlJ.jpg",
            "https://i.imgur.com/0D7NHiJ.jpg",
            "https://i.imgur.com/lHCEKZd.jpg",
            "https://i.imgur.com/UepVBwd.jpg",
            "https://i.imgur.com/Ckgv8oA.jpg",
            "https://i.imgur.com/hWekh6g.jpg",
            "https://i.imgur.com/04PWIEB.jpg",
            "https://i.imgur.com/MQUoLax.jpg",
            "https://i.imgur.com/1vFMTsb.jpg",
            "https://i.imgur.com/93qIWVn.jpg",
            "https://i.imgur.com/qeNlnC2.jpg",
            "https://i.imgur.com/pCFV85L.jpg",
            "https://i.imgur.com/njnNLD3.jpg",
            "https://i.imgur.com/WaqcYMo.jpg",
            "https://i.imgur.com/0HtNM7x.jpg",
            "https://i.imgur.com/j9qG7wL.jpg",
            "http://i1166.photobucket.com/albums/q604/whilee09/IMG_1492_zpsjcbmiy22.jpg",
            "http://i.imgur.com/5lCYDoo.jpg",
            "https://i.imgur.com/ZyOzb16.jpg",
            "https://i.imgur.com/WsZa8on.jpg",
            "https://i.imgur.com/KJn8ie4.jpg",
            "http://i2.wp.com/bklynsizzles.com/wp-content/uploads/2015/10/October_21__2015_at_0754AM-e1445453563602-595x868.jpeg",
            "https://i.imgur.com/o4M8wbj.jpg",
            "https://i.imgur.com/kyownUh.jpg",
            "https://i.imgur.com/xma01tz.jpg",
            "https://i.imgur.com/gbzThvt.jpg",
            "https://i.imgur.com/JgUW6IJ.jpg",
            "https://i.imgur.com/Y2BtHj2.jpg",
            "https://i.imgur.com/yOrenLg.jpg",
            "https://i.imgur.com/tX75w9t.jpg",
            "https://i.imgur.com/Za65VHq.jpg",
            "https://i.imgur.com/1wHRy6Z.jpg",
            "https://i.imgur.com/x5zXZg1.jpg",
            "https://i.imgur.com/DkyjSr4.jpg",
            "https://i.imgur.com/lHcqAJD.jpg",
            "https://i.imgur.com/CBKx6AQ.jpg",
            "https://i.imgur.com/SOFovWa.jpg",
            "http://snag.gy/ZwC2I.jpg",
            "https://i.imgur.com/gdJCYpC.jpg",
            "https://i.imgur.com/1FQHcel.jpg",
            "http://i.imgur.com/VDzK6AS.jpg",
            "https://i.imgur.com/gX7h9W8.jpg",
            "https://i.imgur.com/0CXpb0a.jpg",
            "https://i.imgur.com/5IYBHxd.jpg",
            "https://i.imgur.com/37mmhyI.jpg",
            "https://i.imgur.com/O30Uxni.jpg"
        ]
        
        // compile a list of the facial data for both genders
        print("Analyzing female faces")
        var data = getFacialData(femaleFaces, gender: 0)
        print("Analyzing male faces")
        data += getFacialData(maleFaces, gender: 1)
        
        var trainingInputs: [[Double]] = [ ]
        var trainingOutputs: [[Double]] = [ ]
        
        // convert the facial data into a 2d array to give to the neural network
        for faceData in data
        {
            let inputs: [Double] = [ faceData.eyeSeparation, faceData.faceHeight, faceData.faceWidth, faceData.leftEyeToMouth, faceData.rightEyeToMouth ]
            let outputs: [Double] = [ faceData.gender ]
            
            trainingInputs.append(inputs)
            trainingOutputs.append(outputs)
        }
        
        // you have to mess around with the hiddenLayers and neuronsPerHiddenLayer values
        var currentNetwork = NeuralNetwork(inputs: 5, outputs: 1, hiddenLayers: 1, neuronsPerHiddenLayer: 5)
        
        var lowestError: Double = 1000
        var bestNetwork = currentNetwork
        
        // train the neural network until the error is below our threshold
        while lowestError > 2.1
        {
            do
            {
                try currentNetwork.train(trainingInputs, desiredOutputs: trainingOutputs, learningRate: 0.001)
                
                let computed = try currentNetwork.compute(trainingInputs, expectedOutputs: trainingOutputs)
                let newError = computed.cost
                
                var correct = 0
                var incorrect = 0
                for (index, output) in computed.outputs.enumerate()
                {
                    // supposed to be female
                    if output[0] < 0.5
                    {
                        if trainingOutputs[index][0] == 0
                        {
                            ++correct
                        }
                        else
                        {
                            ++incorrect
                        }
                    }
                    // supposed to be male
                    else
                    {
                        if trainingOutputs[index][0] == 1
                        {
                            ++correct
                        }
                        else
                        {
                            ++incorrect
                        }
                    }
                }
                
                print("correct: ", correct)
                print("incorrect: ", incorrect)
            
                if newError > lowestError
                {
                    currentNetwork = bestNetwork
                }
                else
                {
                    lowestError = newError
                    bestNetwork = currentNetwork
                }
            }
            catch
            {
                print("oops")
            }
            
            print("trainined: ", lowestError)
        }
    }
    
    func distanceBetweenPoints(pointA: CGPoint, pointB: CGPoint) -> Double {
        
        let xDistance = pointA.x - pointB.x
        let yDistance = pointA.y - pointB.y
        let hypotSquared: Double = Double(xDistance * xDistance + yDistance * yDistance)
        
        return sqrt(hypotSquared)
    }
    
    func getFacialData(imageUrls: [String], gender: Double) -> [FacialFeatures]
    {
        var data: [FacialFeatures] = []
        
        for faceUrl in imageUrls
        {
            // get an image of a face
            let faceImage = CIImage(contentsOfURL: NSURL(string: faceUrl)!)
            
            // intialize the facial feature detector
            let facialContext = CIContext(options: nil)
            let facialOptions = [ CIDetectorAccuracy: CIDetectorAccuracyHigh ]
            let facialDetector = CIDetector(ofType: CIDetectorTypeFace, context: facialContext, options: facialOptions)
            
            // print out all the facial features detected
            let faces = facialDetector.featuresInImage(faceImage!)
            for face in faces
            {
                let facialFeatures = face as! CIFaceFeature
                if facialFeatures.hasLeftEyePosition && facialFeatures.hasRightEyePosition && facialFeatures.hasMouthPosition
                {
                    // get the distances between the facial features
                    let features = FacialFeatures()
                    features.eyeSeparation = distanceBetweenPoints(facialFeatures.leftEyePosition, pointB: facialFeatures.rightEyePosition)
                    features.leftEyeToMouth = distanceBetweenPoints(facialFeatures.leftEyePosition, pointB: facialFeatures.mouthPosition)
                    features.rightEyeToMouth = distanceBetweenPoints(facialFeatures.rightEyePosition, pointB: facialFeatures.mouthPosition)
                    features.faceWidth = Double(CGRectGetWidth(facialFeatures.bounds))
                    features.faceHeight = Double(CGRectGetHeight(facialFeatures.bounds))
                    features.gender = gender
                    
                    data.append(features)
                    
                    print("Face Size: \(features.faceWidth) x \(features.faceHeight)")
                    // print("Eye Separation: \(features.eyeSeparation)")
                    // print("Left Eye to Mouth: \(features.leftEyeToMouth)")
                    // print("Right Eye to Mouth: \(features.rightEyeToMouth)")
                }
                else
                {
                    print("Bad image: \(faceUrl)")
                }
            }
        }

        return data
    }
}

