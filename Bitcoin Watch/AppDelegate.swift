import Cocoa
@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var currentPrice = ""
    var btcPrice = ""
    var ltcPrice = ""
    var ethPrice = ""
    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.variableLength)
    let btcMenuItem = NSMenuItem(title: "BTC:", action: nil, keyEquivalent: "")
    let ltcMenuItem = NSMenuItem(title: "LTC:", action: nil, keyEquivalent: "")
    let ethMenuItem = NSMenuItem(title: "ETH:", action: nil, keyEquivalent: "")


    func constructMenu() {
        let menu = NSMenu()
            menu.addItem(btcMenuItem)
            menu.addItem(NSMenuItem.separator())
            menu.addItem(ltcMenuItem)
            menu.addItem(NSMenuItem.separator())
            menu.addItem(ethMenuItem)
            menu.addItem(NSMenuItem.separator())
            menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
            statusItem.menu = menu
        }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let button = statusItem.button {
            button.title = "Loading.."
            button.action = #selector(getUpdates)
            
        }
        _ = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(getUpdates), userInfo: nil, repeats: true)

        constructMenu()
    }
    
    @objc func getUpdates(){
        getBTC()
        getLTC()
        getETH()
    }
    
    @objc func getBTC() {
        let urlString = "https://api.coinbase.com/v2/prices/BTC-USD/buy"
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let request = URLRequest(url: URL(string: urlString)!)
        let task: URLSessionDataTask = session.dataTask(with: request) { (receivedData, response, error) -> Void in
            if let data = receivedData {
                var jsonResponse : [String:AnyObject]?
                do {
                    jsonResponse = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:AnyObject]
                }
                catch {
                    print("Caught exception")
                }
                self.btcPrice = jsonResponse!["data"]!["amount"]!! as! String
            }
        }
        btcMenuItem.title = "BTC: " + btcPrice
        statusItem.button?.title = btcPrice
        task.resume()
    }
    
    @objc func getLTC() {
        let urlString = "https://api.coinbase.com/v2/prices/LTC-USD/buy"
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let request = URLRequest(url: URL(string: urlString)!)
        let task: URLSessionDataTask = session.dataTask(with: request) { (receivedData, response, error) -> Void in
            if let data = receivedData {
                var jsonResponse : [String:AnyObject]?
                do {
                    jsonResponse = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:AnyObject]
                }
                catch {
                    print("Caught exception")
                }
                self.ltcPrice = jsonResponse!["data"]!["amount"]!! as! String
            }
        }
        ltcMenuItem.title = "LTC: " + ltcPrice
        task.resume()
    }
    
    @objc func getETH() {
        let urlString = "https://api.coinbase.com/v2/prices/ETH-USD/buy"
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let request = URLRequest(url: URL(string: urlString)!)
        let task: URLSessionDataTask = session.dataTask(with: request) { (receivedData, response, error) -> Void in
            if let data = receivedData {
                var jsonResponse : [String:AnyObject]?
                do {
                    jsonResponse = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:AnyObject]
                }
                catch {
                    print("Caught exception")
                }
                self.ethPrice = jsonResponse!["data"]!["amount"]!! as! String
            }
        }
        ethMenuItem.title = "ETH: " + self.ethPrice
        task.resume()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
    }
}

