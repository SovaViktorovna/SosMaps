//
//  ViewController.swift
//  SosMaps
//
//  Created by Виктория Демченко on 07.03.25.
//

import UIKit
import MapKit


class ViewController: UIViewController {
    
    private let incrementButton = UIButton(type: .system)
    private let decrementButton = UIButton(type: .system)
    private var lastAnnotation: MKPointAnnotation?
    var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMapView()
        
        setupStepper()
        
        setConstraints()
    }
    
    private func setupMapView() {
        // Добавляем жест нажатия
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleMapTap(_:)))
        mapView.addGestureRecognizer(tapGesture)
    }
    
    private func showInputAlert (coordinate: CLLocationCoordinate2D){
        let alert = UIAlertController(title: "Add a label", message: "Enter the information", preferredStyle: .alert)
        
        alert.addTextField {$0.placeholder = "Location"}
        alert.addTextField { $0.placeholder = "Width"; $0.text = "\(coordinate.latitude)"; $0.isEnabled = false }
        alert.addTextField { $0.placeholder = "Longitude"; $0.text = "\(coordinate.longitude)"; $0.isEnabled = false }
        alert.addTextField { $0.placeholder = "Name" }
        alert.addTextField { $0.placeholder = "Telephone"; $0.keyboardType = .phonePad }
        alert.addTextField { $0.placeholder = "Problem description" }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            let location = alert.textFields?[0].text ?? "Unknown location"
            let name = alert.textFields?[3].text ?? "No name"
            let phone = alert.textFields?[4].text ?? "No phone number"
            let description = alert.textFields?[5].text ?? "There is no description"
            
            self.addAnnotation(coordinate: coordinate, location: location, name: name, phone: phone, description: description)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                if let annotation = self.lastAnnotation {
                    self.mapView.removeAnnotation(annotation)
                    self.lastAnnotation = nil
                }
            }
        // Изначально отключаем кнопку "Add"
        addAction.isEnabled = false
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
        
        // Добавляем наблюдателя для отслеживания изменений в текстовых полях
        for textField in alert.textFields ?? [] {
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: .main) { _ in
                addAction.isEnabled = self.areAllFieldsFilled(in: alert)
                }
            }
    }
    
    // Проверяем, заполнены ли все поля
    private func areAllFieldsFilled(in alert: UIAlertController) -> Bool {
        return alert.textFields?.allSatisfy { !(($0.text ?? "").isEmpty) } ?? false
    }
    
    private func addAnnotation(coordinate: CLLocationCoordinate2D, location: String, name: String, phone: String, description: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
//        annotation.title = "\(name) (\(location))"
//        annotation.subtitle = "📞 \(phone)\n📌 \(description)"
        
        mapView.addAnnotation(annotation)
    }
    
    private func setupStepper() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.layer.cornerRadius = 4
        stackView.clipsToBounds = true
        stackView.layer.borderWidth = 2
        stackView.layer.borderColor = UIColor.lightGray.cgColor
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        incrementButton.setTitle("+", for: .normal)
        incrementButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        incrementButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        incrementButton.tintColor = .black
        incrementButton.backgroundColor = .white
        incrementButton.layer.borderWidth = 1
        incrementButton.layer.borderColor = UIColor.lightGray.cgColor
        incrementButton.addTarget(self, action: #selector(incrementTapped), for: .touchUpInside)
        
        decrementButton.setTitle("-", for: .normal)
        decrementButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        decrementButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        decrementButton.tintColor = .black
        decrementButton.backgroundColor = .white
        decrementButton.addTarget(self, action: #selector(decrementTapped), for: .touchUpInside)
        
        stackView.addArrangedSubview(incrementButton)
        stackView.addArrangedSubview(decrementButton)
        
        mapView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: 16)
        ])
    }
    
    @objc private func incrementTapped() {
        
        changeZoom(scale: 0.5)
    }
    
    @objc private func decrementTapped() {
        
        changeZoom(scale: 2.0)
    }
    
    @objc private func handleMapTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        
        // Создаем метку и сохраняем
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        lastAnnotation = annotation
        
        showInputAlert(coordinate: coordinate)
        
        mapView.addAnnotation(annotation)
    }
    
    func changeZoom(scale: Double) {
        var region = mapView.region
        region.span.latitudeDelta *= CGFloat(scale)
        region.span.longitudeDelta *= CGFloat(scale)
        mapView.setRegion(region, animated: true)
    }
}

extension ViewController {
    
    func setConstraints() {
        
        view.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
}


