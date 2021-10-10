//
//  BaseViewController.swift
//  TMDB
//
//  Created by Zaw Zin Phyo on 09/10/2021.
//

import UIKit
import PKHUD
import RxSwift

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

extension BaseViewController {
    
    func showLoading() {
        HUD.show(.progress)
    }
    
    func hideLoading() {
        HUD.hide(animated: true, completion: nil)
    }
    
    var isLoading: Binder<Bool> {
        return Binder(self, binding: { (vc, active) in
            if active {
                self.showLoading()
            } else {
                self.hideLoading()
            }
        })
    }
    
    func showAlert(title: String? = "", message: String?, actionTitle: String = "Retry", actionCallback: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { (_) in
            actionCallback?()
        }))
        present(alertController, animated: true, completion: nil)
    }
}
