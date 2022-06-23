//
//  BarCodeCV.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/6/24.
//

import UIKit

import AVFoundation
import Vision
import VisionKit

class BarCodeVC
: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    @IBAction func test(_ sender: Any) {
        
        let documentCameraViewController = VNDocumentCameraViewController()
        documentCameraViewController.delegate = self
        
        addChild(documentCameraViewController)
        view.addSubview(documentCameraViewController.view)
        documentCameraViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        documentCameraViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        documentCameraViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        documentCameraViewController.view.heightAnchor.constraint(equalToConstant: 500).isActive = true
        documentCameraViewController.didMove(toParent: self)
        
        //present(documentCameraViewController, animated: true)
    }
    
  
    func processImage(image: UIImage) {
        guard let cgImage = image.cgImage else {
            print("Failed to get cgimage from input image")
            return
        }
        let handler = VNImageRequestHandler(cgImage: cgImage)
        let request = VNDetectBarcodesRequest { request, error in
            if let observation = request.results?.first as? VNBarcodeObservation,
               observation.symbology == .qr {
                print(observation.payloadStringValue ?? "")
            }
        }
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
    }
    
    
}

extension BarCodeVC: VNDocumentCameraViewControllerDelegate {
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        let image = scan.imageOfPage(at: scan.pageCount - 1)
        processImage(image: image)
        dismiss(animated: true, completion: nil)
    }
}
