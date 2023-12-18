//
//  MVPExampleView.swift
//  SkillboxDrive
//
//  Created by Евгений Капанов on 14.12.2023.
//

import UIKit

protocol MVPExampleViewDelegate: AnyObject {}

final class MVPExampleView: UIView {
    
    struct ViewModel {
        let title: String
        let firstText: String
        let secondText: String
    }

    weak var delegate: MVPExampleViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MVPExampleView {
    func set(viewModel: ViewModel) {
        
    }
}
