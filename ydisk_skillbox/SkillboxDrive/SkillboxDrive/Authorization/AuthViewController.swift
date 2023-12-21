//
//  AuthViewController.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 06.11.2023.
//

import Foundation
import WebKit

// MARK: - Keys for UserDefaults
enum Keys {
    static let apiToken = "apiToken"
}

protocol AuthViewControllerDelegate: AnyObject {
    
    func handleTokenChanged(token: String)
}

final class AuthViewController: UIViewController {
    
    // MARK: - Public properties
    
    weak var delegate: AuthViewControllerDelegate?
    
    // MARK: - Private properties
    
    private let scheme = "https"
    private let webView = WKWebView()
    private let clientId = "1e126bd76e7e4406bf4d15babd07e8d8"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        
        guard let request = request else { return }
        webView.load(request)
        webView.navigationDelegate = self
    }
    
    private func configureViews() {
        
        view.backgroundColor = .white
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private var request: URLRequest? {
        
        guard var urlComponents = URLComponents(string: "https://oauth.yandex.ru/authorize") else { return nil }
        urlComponents.queryItems = [
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "client_id", value: "\(clientId)"),
        ]
        
        guard let url = urlComponents.url else { return nil }
        
        return URLRequest(url: url)
    }
}

extension AuthViewController: WKNavigationDelegate {
    
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        
        if let url = navigationAction.request.url, url.scheme == scheme {
            
            let targetString = url.absoluteString.replacingOccurrences(of: "#", with: "?")
            guard let components = URLComponents(string: targetString) else { return }
            
            let token = components.queryItems?.first(where: { $0.name == "access_token" })?.value
            
            if let token = token {
                delegate?.handleTokenChanged(token: token)
                UserDefaults.standard.set(token, forKey: Keys.apiToken)
                dismiss(animated: true, completion: nil)
            }
        } else {
            print("url.scheme invalid")
        }
        decisionHandler(.allow)
    }
}
