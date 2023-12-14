//
//  OpenFolderVC.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 02.12.2023.
//

import UIKit

final class OpenFolderVC: UIViewController {

    // MARK: - Private variables
    private let cellIdentifier = "cellIdentifier"
    private let presenter: OpenFolderPresenterProtocol = OpenFolderPresenter()
    private let refreshControl = UIRefreshControl()
    private var activityIndicator = UIActivityIndicatorView()
    private var activityIndicatorView = UIView()
    private var tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.grouped)
    private var backButton = UIBarButtonItem()
    private var errorView = UIView()
    private var errorLabel = UILabel()
    private var titleOfFolder: String?
    private var type: String?
    private var path: String?
    private var emptyFolderErrorView = UIView()
    private let labelError = UILabel()
    private let fileNotFound = UILabel()
    
    // MARK: - Initialization
    init(title: String?,
         type: String?,
         pathFolder: String?
        ) {
        super.init(nibName: nil, bundle: nil)
        self.titleOfFolder = title
        self.type = type
        self.path = pathFolder ?? "disk:/"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = titleOfFolder
        view.backgroundColor = .systemBackground
        configureNavigationBar()
        configureActivityIndicatorView()
        updateView()
    }

    // MARK: - Configure methods
    private func configureNavigationBar() {
    
        backButton = UIBarButtonItem(
            image: Constants.Image.backArrow,
            style: .plain,
            target: self,
            action: #selector(didTappedOnBackButton)
        )
        backButton.tintColor = Constants.Colors.gray
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func didTappedOnBackButton() {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    private func configureEmptyFolderError() {
        
        labelError.text = Constants.Text.emptyFolder
        labelError.textColor = .black
        labelError.numberOfLines = 0
        labelError.textAlignment = .center
        
        view.addSubview(emptyFolderErrorView)
        emptyFolderErrorView.backgroundColor = .systemBackground
        emptyFolderErrorView.addSubview(labelError)
        
        labelError.translatesAutoresizingMaskIntoConstraints = false
        emptyFolderErrorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            emptyFolderErrorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            emptyFolderErrorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyFolderErrorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyFolderErrorView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            labelError.centerXAnchor.constraint(equalTo: emptyFolderErrorView.centerXAnchor),
            labelError.centerYAnchor.constraint(equalTo: emptyFolderErrorView.centerYAnchor),
            labelError.heightAnchor.constraint(equalToConstant: 100),
            labelError.leadingAnchor.constraint(equalTo: emptyFolderErrorView.leadingAnchor, constant: 70),
            labelError.trailingAnchor.constraint(equalTo: emptyFolderErrorView.trailingAnchor, constant: -70),
        ])
    }

    private func configureActivityIndicatorView() {
        
        view.addSubview(activityIndicatorView)
        activityIndicatorView.backgroundColor = .systemBackground
        activityIndicatorView.addSubview(activityIndicator)
        
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
        
        NSLayoutConstraint.activate([
            activityIndicatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            activityIndicatorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            activityIndicatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            activityIndicatorView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: activityIndicatorView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: activityIndicatorView.centerYAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: 50),
            activityIndicator.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    private func configureTableView() {
        
        refreshControl.addTarget(self, action: #selector(didSwipeToRefresh), for: .valueChanged)
        tableView.refreshControl = self.refreshControl
        tableView.register(LatestCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        configureConstraints()
    }
    
    @objc private func didSwipeToRefresh() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.updateDataOfTableView()
            self?.tableView.refreshControl?.endRefreshing()
        }
    }

    private func configureConstraints() {
        
        tableView.isHidden = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
        ])
    }
    
    // MARK: - Configure Error View
    private func configureErrorView() {
        
        errorLabel.text = Constants.Text.errorInternet
        errorLabel.font = .systemFont(ofSize: 15, weight: .regular)
        errorLabel.textColor = .white
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 0
        errorView.backgroundColor = Constants.Colors.red
        
        errorView.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorView.addSubview(errorLabel)
        view.addSubview(errorView)
        
        NSLayoutConstraint.activate([
            errorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            errorView.heightAnchor.constraint(equalToConstant: 50),
            
            errorLabel.topAnchor.constraint(equalTo: errorView.topAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: errorView.leadingAnchor, constant: 80),
            errorLabel.trailingAnchor.constraint(equalTo: errorView.trailingAnchor, constant: -80),
            errorLabel.bottomAnchor.constraint(equalTo: errorView.bottomAnchor),
        ])
    }
    
    // MARK: - UpdateView
    
    private func updateView() {

        configureTableView()
        updateDataOfTableView()
    }
    
    private func updateDataOfTableView() {
        
        presenter.updateDataTableView(path: path) {
            DispatchQueue.main.async {
                self.errorView.removeFromSuperview()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                guard let self = self else { return }
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
                self.activityIndicatorView.removeFromSuperview()
                self.tableView.isHidden = false
            }
        } errorHandler: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                guard let self = self else { return }
                self.activityIndicator.stopAnimating()
                self.activityIndicatorView.removeFromSuperview()
                self.configureEmptyFolderError()
            }
        } noInternet: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                guard let self = self else { return }
                self.activityIndicator.stopAnimating()
                self.activityIndicatorView.removeFromSuperview()
                self.tableView.reloadData()
                self.tableView.isHidden = false
                self.configureErrorView()
            }
        }
    }
    
    // MARK: - Footer View
    private func createLoadingFooterView() -> UIView {
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        
        return footerView
    }
}

extension OpenFolderVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        presenter.getModelData().items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? LatestCell
        guard let viewModel = presenter.getModelData().items, viewModel.count > indexPath.row else {
            return UITableViewCell()
        }
        let item = viewModel[indexPath.row]
        cell?.configureCell(item)
        cell?.backgroundColor = .white
        return cell ?? UITableViewCell()
    }
}

extension OpenFolderVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        configureActivityIndicatorView()
        
        guard let viewModel = presenter.getModelData().items else {
            print("error getModelData")
            return
        }
        guard let title = viewModel[indexPath.row].name else { return }
        guard let created = viewModel[indexPath.row].created else { return }
        let fileUrl = viewModel[indexPath.row].file ?? "ljshdlgfhj"
        guard let pathItem = viewModel[indexPath.row].path else { return }
        let fileType = presenter.determinationOfFileType(path: pathItem)

        let folder = "dir"
        if fileType == folder {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                guard let self = self else { return }
                let vc = OpenFolderVC(title: title, type: fileType, pathFolder: pathItem)
                self.navigationController?.pushViewController(vc, animated: true)
                self.activityIndicator.stopAnimating()
                self.activityIndicatorView.removeFromSuperview()
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                guard let self = self else { return }
                let vc = ViewingScreenViewController(title: title, created: created, type: fileType, file: fileUrl, path: pathItem)
                vc.modalPresentationStyle = .fullScreen
                self.navigationController?.present(vc, animated: true, completion: {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicatorView.removeFromSuperview()
                })
            }
        }
    }
}

extension OpenFolderVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let deltaOffset = maximumOffset - currentOffset
        
        if deltaOffset <= 0, currentOffset >= 50 {

            guard !self.presenter.isPaginating() else {
                print("We are already fetching more data")
                return
            }
            self.tableView.tableFooterView = createLoadingFooterView()
            self.presenter.additionalGettingFiles(path: path) { [weak self] in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self?.tableView.tableFooterView = nil
                    self?.tableView.reloadData()
                    self?.presenter.changePaginatingStateOnFalse()
                }
            } errorHandler: { [weak self] in
                print("additional errorHandler")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self?.tableView.tableFooterView = nil
                    self?.tableView.reloadData()
                    self?.presenter.changePaginatingStateOnFalse()
                }
            }
        }
    }
}


