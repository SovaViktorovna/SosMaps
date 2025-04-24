//
//  DetailsViewController.swift
//  SosMaps
//
//  Created by Виктория Демченко on 02.04.25.
//
import UIKit

class DetailsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        let dismissButton = UIButton(frame: CGRect(x: 20, y: 50, width: 100, height: 40))
        dismissButton.setTitle("Закрыть", for: .normal)
        dismissButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        view.addSubview(dismissButton)
    }
    
    @objc func dismissView() {
        dismiss(animated: true)
    }
}
