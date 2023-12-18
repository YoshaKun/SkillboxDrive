//
//  MVPExampleViewController.swift
//  SkillboxDrive
//
//  Created by Евгений Капанов on 14.12.2023.
//

import UIKit

final class MVPExampleViewController: UIViewController {

    // MARK: - Private properties

    private let presenter: MVPExamplePresenterInput
    private let mainView: MVPExampleView = .init()

    init(presenter: MVPExamplePresenterInput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Override methods

    override func loadView() {
        super.loadView()

        mainView.delegate = self

        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - MVPExamplePresenterOutput

extension MVPExampleViewController: MVPExamplePresenterOutput {
    func didSuccessUpdateDataTableView() {
        
    }
    
    func didFailureUpdateDataTableView() {
        
    }
    
    func startLoader() {
        
    }
    
    func hideLoader() {
        
    }
}

// MARK: - MVPExampleViewDelegate

extension MVPExampleViewController: MVPExampleViewDelegate {}
