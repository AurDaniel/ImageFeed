import UIKit
import WebKit

final class WebViewViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    private struct WebConstants {
        static let authorizeURL = "https://unsplash.com/oauth/authorize"
        static let code = "code"
        static let authorizePath = "/oauth/authorize/native"
    }
    
    var delegate: WebViewViewControllerDelegate?
    
    @IBOutlet private var webView: WKWebView!
    @IBOutlet private var progressView: UIProgressView!
    
    @IBAction private func didTapBackButton(_ sender: Any?) {
        delegate?.webViewViewControllerDidCancel(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var preferredStatusBarStyle: UIStatusBarStyle {
            .lightContent
        }
        webView.navigationDelegate = self
        loadWebView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        webView.addObserver(
            self,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            options: .new,
            context: nil)
        updateProgress()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            updateProgress()
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
}

private extension WebViewViewController {
    func loadWebView() {
        var urlComponents = URLComponents(string: WebConstants.authorizeURL)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "response_type", value: WebConstants.code),
            URLQueryItem(name: "scope", value: Constants.accessScope)
        ]
        
        if let url = urlComponents.url {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}

extension WebViewViewController: WKNavigationDelegate {
    func webView(
        _ webView:WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            
            print("Вот оно", navigationAction.request.url ?? "Pizdet")
            
            if let code = fetchCode(url: navigationAction.request.url) {
                delegate?.webViewViewController(self, didAuthenticateWithCode: code)
                decisionHandler(.cancel)
            } else {
                decisionHandler(.allow)
            }
        }
    
    private func fetchCode(url: URL?) -> String? {
        guard let url = url,
              let components = URLComponents(string: url.absoluteString),
              components.path == WebConstants.authorizePath,
              let codeItem = components.queryItems?.first(where: { $0.name == "code" })
        else { return nil }
        
        return codeItem.value
    }
}
