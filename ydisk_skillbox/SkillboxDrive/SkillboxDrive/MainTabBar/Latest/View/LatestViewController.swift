//
//  ViewController.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 05.10.2023.
//

import UIKit

final class LatestViewController: UIViewController {

    // MARK: - Private variables
    private let latestCell = "latestCell"
    private let presenter: LatestPresenterInput
    private let refreshControl = UIRefreshControl()
    private var activityIndicator = UIActivityIndicatorView()
    private var activityIndicatorView = UIView()
    private var tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.grouped)
    private var errorView = UIView()
    private var errorLabel = UILabel()
    private var noInternetFlag = false

    // MARK: - Initialization

    init(presenter: LatestPresenterInput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        configureNavigationBar()
        configureActivityIndicatorView()
        updateView()
    }

    // MARK: - Configure methods
    private func configureNavigationBar() {

        navigationItem.title = Constants.SecondVC.title
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
            activityIndicator.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func configureTableView() {

        refreshControl.addTarget(self, action: #selector(didSwipeToRefresh), for: .valueChanged)
        tableView.refreshControl = self.refreshControl
        tableView.register(LatestCell.self, forCellReuseIdentifier: latestCell)
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
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
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
            errorLabel.bottomAnchor.constraint(equalTo: errorView.bottomAnchor)
        ])
    }

    // MARK: - Update Data
    private func updateView() {

        configureTableView()
        updateDataOfTableView()
    }

    private func updateDataOfTableView() {

        presenter.updateDataTableView()
    }

    // MARK: - DeterminationOfFileType
    func determinationOfFileType(path: String) -> String {
        let index = path.firstIndex(of: ".") ?? path.endIndex
        var fileType = path[index ..< path.endIndex]
        fileType.removeFirst()
        let newString = String(fileType)
        return newString
    }

    // MARK: - Footer view
    private func createLoadingFooterView() -> UIView {

        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()

        return footerView
    }
}

// MARK: - LatestPresenterOutput

extension LatestViewController: LatestPresenterOutput {

    func didSuccessUpdateTableView() {
        DispatchQueue.main.async {
            self.errorView.removeFromSuperview()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.noInternetFlag = false
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
            self.activityIndicatorView.removeFromSuperview()
            self.tableView.isHidden = false
        }
    }

    func noInternetUpdateTableView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            self.noInternetFlag = true
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
            self.activityIndicatorView.removeFromSuperview()
            self.tableView.isHidden = false
            self.configureErrorView()
        }
    }

    func didSuccessGetFileFromPath(
        title: String?,
        created: String?,
        type: String?,
        file: String?,
        path: String?
    ) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            let newVc = ViewingScreenBuilder.build(
                title: title,
                created: created,
                type: type,
                file: file,
                path: path
            )
            newVc.modalPresentationStyle = .fullScreen
            self.navigationController?.present(
                newVc,
                animated: true,
                completion: {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicatorView.removeFromSuperview()
                }
            )
        }
    }

    func didFailureGetFileFromPath() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.updateDataOfTableView()
            self.activityIndicator.stopAnimating()
            self.activityIndicatorView.removeFromSuperview()
        }
    }

    func didSuccessAdditionalGettingFiles() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.tableView.tableFooterView = nil
            self.tableView.reloadData()
            self.presenter.changePaginatingStateOnFalse()
        }
    }

    func didFailureAdditionalGettingFiles() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.tableView.tableFooterView = nil
            self.tableView.reloadData()
            self.presenter.changePaginatingStateOnFalse()
        }
    }
}

extension LatestViewController: UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        guard noInternetFlag == false else {
            let modelCount = presenter.fetchLatestModelFromCoreData().items?.count
            return modelCount ?? 0
        }
        return presenter.getModelData().items?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: latestCell) as? LatestCell

        guard noInternetFlag == false else {

            // MARK: - If there is no an Internet - so model fetching from CoreData

            guard let viewModel = presenter.fetchLatestModelFromCoreData().items,
                  viewModel.count > indexPath.row
            else {
                return UITableViewCell()
            }
            let item = viewModel[indexPath.row]
            cell?.configureCell(item)
            cell?.backgroundColor = .white
            return cell ?? UITableViewCell()
        }

        // MARK: - If the Internet is ON - so model fetching from Server

        guard let viewModel = presenter.getModelData().items,
              viewModel.count > indexPath.row
        else {
            return UITableViewCell()
        }
        let item = viewModel[indexPath.row]
        cell?.configureCell(item)
        cell?.backgroundColor = .white
        return cell ?? UITableViewCell()
    }
}

extension LatestViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        configureActivityIndicatorView()

        guard let viewModel = presenter.getModelData().items else { return }
        guard let title = viewModel[indexPath.row].name else { return }
        guard let created = viewModel[indexPath.row].created else { return }
        guard let fileUrl = viewModel[indexPath.row].file else { return }
        guard let pathItem = viewModel[indexPath.row].path else { return }
        let fileType = determinationOfFileType(path: pathItem)

        presenter.getFileFromPath(
            title: title,
            created: created,
            type: fileType,
            file: fileUrl,
            path: pathItem
        )
    }
}

extension LatestViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let deltaOffset = maximumOffset - currentOffset

        if deltaOffset <= 0, currentOffset >= 50 {

            guard !self.presenter.isPaginating() else {
                return
            }
            self.tableView.tableFooterView = createLoadingFooterView()
            self.presenter.additionalGetingLatestFiles()
        }
    }
}
