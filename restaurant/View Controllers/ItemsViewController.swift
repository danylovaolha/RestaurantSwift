
import UIKit

class ItemsViewController: UITableViewController {
    
    private var items: [Any]?
    private let FAVORITES = "Favorites"
    private let NEWS = "News"
    private let backendless = Backendless.sharedInstance()!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setToolbarHidden(true, animated: true)
        if(navigationItem.title == FAVORITES) {
            items = UserDefaultsHelper.shared.getFavoriteMenuItems()
            tableView.reloadData()
        }
        else if (navigationItem.title == NEWS) {
            backendless.data.of(Article.ofClass()).find({ articles in
                self.items = articles
                self.tableView.reloadData()
            }, error: { fault in
                AlertViewController.showErrorAlert(fault!, self, nil)
            })
        }
        else {
            let queryBuilder = DataQueryBuilder()!
            queryBuilder.setWhereClause(String(format:"category.title='%@'", navigationItem.title!))
            backendless.data.of(MenuItem.ofClass()).find(queryBuilder, response: { menuItems in
                self.items = menuItems
                self.tableView.reloadData()
            }, error: { fault in
                AlertViewController.showErrorAlert(fault!, self, nil)
            })
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (items != nil) {
            return (items?.count)!
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        if (items?.first is MenuItem) {
            let menuItem = items![indexPath.row] as! MenuItem
            cell.titleLabel.text = menuItem.title
            cell.descriptionLabel.text = menuItem.body
            if let picture = menuItem.pictures?.firstObject {
                PictureHelper.shared.setSmallImageFromUrl((picture as! Picture).url!, cell)
            }
        }
        else if (items?.first is Article) {
            let article = items![indexPath.row] as! Article
            cell.titleLabel.text = article.title
            cell.descriptionLabel.text = article.body
            PictureHelper.shared.setSmallImageFromUrl((article.picture?.url)!, cell)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if (navigationItem.title == FAVORITES) {
            return true
        }
        return false
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let menuItem = items![indexPath.row] as! MenuItem
            UserDefaultsHelper.shared.removeItemFromFavorites(menuItem)
            items = UserDefaultsHelper.shared.getFavoriteMenuItems()
            tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ShowItemDetails") {
            let itemDetailsVC = segue.destination as! ItemDetailsViewController
            let indexPath = tableView.indexPath(for: sender as! ItemCell)!
            itemDetailsVC.item = items?[indexPath.row]
        }
    }
    
    @IBAction func unwindToItemsVC(segue:UIStoryboardSegue) {
    }    
}
