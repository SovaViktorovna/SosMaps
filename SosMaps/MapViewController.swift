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
        let alert = UIAlertController(title: "Добавить метку", message: "Введите информацию", preferredStyle: .alert)
        
        alert.addTextField {$0.placeholder = "Местоположение (авто)"}
        alert.addTextField { $0.placeholder = "Широта"; $0.text = "\(coordinate.latitude)"; $0.isEnabled = false }
        alert.addTextField { $0.placeholder = "Долгота"; $0.text = "\(coordinate.longitude)"; $0.isEnabled = false }
        alert.addTextField { $0.placeholder = "Имя" }
        alert.addTextField { $0.placeholder = "Телефон"; $0.keyboardType = .phonePad }
        alert.addTextField { $0.placeholder = "Описание проблемы" }
        
        let addAction = UIAlertAction(title: "Добавить", style: .default) { _ in
            let location = alert.textFields?[0].text ?? "Неизвестное место"
            let name = alert.textFields?[3].text ?? "Нет имени"
            let phone = alert.textFields?[4].text ?? "Нет телефона"
            let description = alert.textFields?[5].text ?? "Нет описания"
            
            self.addAnnotation(coordinate: coordinate, location: location, name: name, phone: phone, description: description)}
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(addAction)
        present(alert, animated: true)
    }
    
    private func addAnnotation(coordinate: CLLocationCoordinate2D, location: String, name: String, phone: String, description: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "\(name) (\(location))"
        annotation.subtitle = "📞 \(phone)\n📌 \(description)"
        
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
        
        // Создаем метку
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "New mark"
        
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


