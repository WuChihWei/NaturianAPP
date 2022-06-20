//
//  PhotoManager.swift
//  NaturianAPP
//
//  Created by Jordan Wu on 2022/6/19.
//

import UIKit

struct PhotoManager {
    
    func tapPhoto(controller: UIViewController) {
        
        let alertController = UIAlertController(title: "Camera? Gallery? Album?", message: "", preferredStyle: .alert)
        alertController.view.tintColor = UIColor.gray
        
        // Camera
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
            //self.takePicture()
        }
        alertController.addAction(cameraAction)
        
        // Photo
        let photoLibraryAction = UIAlertAction(title: "Gallery", style: .default) { _ in
            //self.openPhotoLibrary()
        }
        alertController.addAction(photoLibraryAction)
        
        // Gallery
        let savedPhotoAlbumAction = UIAlertAction(title: "Album", style: .default) { _ in
            //self.openPhotosAlbum()
        }
        alertController.addAction(savedPhotoAlbumAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alertController.addAction(cancelAction)
        
        controller.present(alertController, animated: true, completion: nil)
    }
    
}
