import UIKit
struct Welcome: Codable {
    let body: Body
    let status: Int
}


struct Body: Codable {
    let services: [Service]
}


struct Service: Codable {
    let name, serviceDescription: String
    let link: String
    let iconURL: String

    enum CodingKeys: String, CodingKey {
        case name
        case serviceDescription = "description"
        case link
        case iconURL = "icon_url"
    }
}

extension UIImageView {
    func load(urlString : String) {
        guard let url = URL(string: urlString)else {
            return
        }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}


class AppTableViewController: UITableViewController {
    var welcome = Welcome(body: Body(services:[Service(name: "", serviceDescription: "", link: "", iconURL: "")]), status: 1)

    override func viewDidLoad() {
        super.viewDidLoad()
        if let url1 = URL(string:"https://publicstorage.hb.bizmrg.com/sirius/result.json"){
            do{
                let contents = try String(contentsOf: url1)
                let inputData = contents.data(using: .utf8)!
                let decoder = JSONDecoder()
                welcome = try! decoder.decode(Welcome.self, from: inputData)
            }catch{
                print("catch")
            }
        }else{
            print("else")
        }

        self.title = "Сервисы VK"
    }



    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return welcome.body.services.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "appCell", for: indexPath) as! AppTableViewCell
        let element = welcome.body.services[indexPath.row]
        cell.appDescription.text = element.serviceDescription
        cell.appName.text = element.name
        cell.appDescription.numberOfLines = 0
        cell.appImage.load(urlString: element.iconURL)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = URL(string: welcome.body.services[indexPath.row].link)!
        UIApplication.shared.openURL(url)
    }
    
}
