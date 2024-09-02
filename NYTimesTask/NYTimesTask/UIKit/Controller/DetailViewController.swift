//
//  DetailViewController.swift
//  NYTimesTask
//
//  Created by Monish Kumar on 02/09/24.
//

import SwiftUI
import UIKit
import WebKit

struct DetailsViewControllerWrapper: UIViewControllerRepresentable {
    var urlString: String

    func makeUIViewController(context: Context) -> UIViewController {
        // Instantiate your UIKit view controller here
        let viewController = DetailsViewController(urlString: urlString)
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Update the view controller if needed
    }
}

class DetailsViewController: UIViewController, WKUIDelegate, WKNavigationDelegate, ActivityIndicatorViewable {
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()

    private let urlString: String?

    init(urlString: String) {
        self.urlString = urlString
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavItem()
        view.addSubview(webView)
        webView.spaceAround()
        startAnimating(CGSize(width: 150, height: 150), message: "Loading...", type: .ballScaleMultiple, fadeInAnimation: nil)
        configueWebView()
        // Do any additional setup after loading the view.
    }

    func configueWebView() {
        DispatchQueue.global(qos: .background).async {
            let myRequest = URLRequest(url: URL(string: self.urlString ?? "")!)
            DispatchQueue.main.async {
                self.webView.load(myRequest)
            }
        }
    }

    func setupNavItem() {
        title = "NYTimesDetails"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeAction))
    }

    @objc func closeAction() {
        dismiss(animated: true)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        stopAnimating()
    }
}
