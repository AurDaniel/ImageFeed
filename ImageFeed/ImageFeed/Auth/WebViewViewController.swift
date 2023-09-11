import UIKit
import WebKit

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vs: WebViewViewController)
}


final class WebViewViewController: UIViewController {
    
    private struct WebConstants {
        static let authorizeURL = "https://unsplash.com/oauth/authorize"
        static let code = "code"
        static let authorizePath = "/oauth/authorize/native"
    }
    
    var delegate: WebViewViewControllerDelegate?
    
    @IBOutlet private var webView: WKWebView!
    
    @IBAction private func didTapBackButton(_ sender: Any?) {
        delegate?.webViewViewControllerDidCancel(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadWebView()
        webView.navigationDelegate = self
    }
}

private extension WebViewViewController {
    func loadWebView() {
        var urlComponents = URLComponents(string: WebConstants.authorizeURL)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.AccessKey),
            URLQueryItem(name: "redirect_uri", value: Constants.RedirectURI),
            URLQueryItem(name: "response_type", value: WebConstants.code),
            URLQueryItem(name: "scope", value: Constants.AccessScope)
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
