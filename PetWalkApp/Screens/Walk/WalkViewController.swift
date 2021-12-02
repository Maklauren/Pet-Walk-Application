//
//  WalkViewController.swift
//  PetWalkApp
//
//  Created by Павел Черноок on 1.12.21.
//

import UIKit
import RxSwift
import CoreLocation
import MapKit

class WalkViewController: BaseViewController, CLLocationManagerDelegate {
    
    private var viewModel: WalkViewModel!
    private let disposeBag = DisposeBag()
    
    private var screenTitle = UILabel()
    
    private let locationManager = CLLocationManager()
    
    private let mapView = MKMapView(frame: .zero)
    
    private var didZoomInitially = false
    
    var endTheWalkButton = Stylesheet().createButton(buttonText: "End the walk", buttonColor: "Background", textColor: UIColor.black)
    
    override func viewDidAppear(_ animated: Bool) {
        checkAuthorizationAndRequestLocation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        locationManager.stopUpdatingLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        
        view.backgroundColor = UIColor(named: "Background")
        
        view.addSubview(screenTitle)
        view.addSubview(mapView)
        view.addSubview(endTheWalkButton)
        
        [screenTitle, mapView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            screenTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            screenTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
            
            mapView.topAnchor.constraint(equalTo: screenTitle.bottomAnchor, constant: 5),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -150),
            
            endTheWalkButton.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 15),
            endTheWalkButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
            endTheWalkButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22),
            endTheWalkButton.heightAnchor.constraint(equalToConstant: 53),
        ])
        
        screenTitle.textColor = UIColor.black
        screenTitle.font = UIFont.systemFont(ofSize: 39, weight: UIFont.Weight.heavy)
        screenTitle.text = "Walk"
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
    }
    
    func bind(viewModel: WalkViewModel) {
        self.viewModel = viewModel
        
        endTheWalkButton.rx.tap
            .bind(onNext: viewModel.endTheWalkButtonTapped)
            .disposed(by: disposeBag)
    }
    
    func checkAuthorizationAndRequestLocation() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case . denied:
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!,
                                      options: [:], completionHandler: nil)
        default:
            locationManager.startUpdatingLocation()
        }
    }
}

extension WalkViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if !didZoomInitially {
            didZoomInitially = true
            mapView.showAnnotations([mapView.userLocation], animated: true)
        }
    }
}
