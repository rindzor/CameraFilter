//
//  ViewController.swift
//  CameraFilter
//
//  Created by  mac on 9/7/20.
//  Copyright © 2020 Vladimir Drozdin. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var photoImageView: UIImageView!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func updateUI(with image: UIImage) {
        self.photoImageView.image = image
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let nc = segue.destination as? UINavigationController,
            let photosCollectionVC = nc.viewControllers.first as? PhotoCollectionVC else {
                fatalError("Segue is not find")
        }
        
        photosCollectionVC.selectedPhotoObserver.subscribe(onNext: { [weak self] (image) in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.updateUI(with: image)
                self.filterButton.isHidden = false
            }
            
        }).disposed(by: disposeBag)
    }
    
    @IBAction func applyButtonPressed(_ sender: Any) {
        
        guard let sourceImage = photoImageView.image else { return }
        FilterService().applyFilter(to: sourceImage)
            .subscribe (onNext :{ [weak self] (filteredImage) in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    self.photoImageView.image = filteredImage
                }
            }).disposed(by: disposeBag)
        
//        FilterService().applyFilter(to: sourceImage) { [weak self] (processedImage) in
//            DispatchQueue.main.async {
//                guard let self = self else { return }
//                self.photoImageView.image = processedImage
//            }
//        }
        
    }
    
}

