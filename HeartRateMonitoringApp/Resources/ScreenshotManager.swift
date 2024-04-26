//
//  File.swift
//  HeartRateMonitoringApp
//
//  Created by João Rouxinol on 25/04/2024.
//

import Foundation
import UIKit
import SwiftUI
import Combine

class ScreenshotManager: NSObject {
    var statePublisher = PassthroughSubject<ImageSaveResult, Never>()
    
    func captureScreenshot(of customView: some View, event: ScreenShotEvent = .share) {
        let hostingController = UIHostingController(rootView: customView)
        hostingController.view.frame = UIScreen.main.bounds
        hostingController.overrideUserInterfaceStyle = .light
        let renderer = UIGraphicsImageRenderer(bounds: hostingController.view.bounds)
        
        let screenshot = renderer.image { ctx in
            hostingController.view.drawHierarchy(in: hostingController.view.bounds, afterScreenUpdates: true)
        }
        switch event {
        case .save:
            saveScreenShot(screenshot)
        case .share:
            shareScreenShot(screenshot)
        }
    }
    
    func shareScreenShot(_ screenshot: UIImage) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let window = windowScene.windows.first else {
            return
        }
        let activityViewController = UIActivityViewController(activityItems: [screenshot], applicationActivities: nil)
        if let topViewController = window.rootViewController {
            topViewController.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    func saveScreenShot(_ screenshot: UIImage) {
        UIImageWriteToSavedPhotosAlbum(screenshot, self, #selector(imageSavedToPhotoLibrary(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func imageSavedToPhotoLibrary(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            statePublisher.send(.failure)
        } else {
            statePublisher.send(.success)
        }
    }
}
