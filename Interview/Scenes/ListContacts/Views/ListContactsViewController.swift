import UIKit

// Aqui ela é Static pois os métodos e propriedades pertencem a struct como um todo e não a uma instância da struct

struct UserIdsLegacy {
    static let legacyIds = [10, 11, 12, 13]
    
    static func isLegacy(id: Int) -> Bool {
        return legacyIds.contains(id)
    }
}

class ListContactsViewController: UIViewController {
    
    // MARK: - UI Components
    
    private lazy var activity: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.hidesWhenStopped = true
        activity.startAnimating()
        return activity
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 120
        tableView.register(ContactCell.self, forCellReuseIdentifier: String(describing: ContactCell.self))
        tableView.backgroundView = activity
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    var contacts = [Contact]()
    var viewModel: ListContactsViewModel!
    
    // MARK: - Initializers
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        
        navigationController?.title = "Lista de contatos"
        
        loadData()
    }
    
    // MARK: - Private methods
    
    private func isLegacy(contact: Contact) -> Bool {
        return UserIdsLegacy.isLegacy(id: contact.id)
    }
    
    private func loadData() {
        viewModel.loadContacts { [weak self] contacts, error in
            guard let self else { return }
            if let error {
                print(error)
                
                let alert = UIAlertController(title: "Ops, ocorreu um erro", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
                return
            }
            
            self.contacts = contacts ?? []
            self.tableView.reloadData()
            self.activity.stopAnimating()
        }
    }
    
    // MARK: - Configure View
    
    private func configureViews() {
        view.backgroundColor = .red
        configureViewsHierarchy()
        configureViewConstraints()
    }
    
    private func configureViewConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
    
    private func configureViewsHierarchy() {
        view.addSubview(tableView)
    }
    
}


// MARK: - Table View Setups

extension ListContactsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ContactCell.self), for: indexPath) as? ContactCell else {
            return UITableViewCell()
        }
        let contact = contacts[indexPath.row]
        cell.configureCell(with: contact)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contato = contacts[indexPath.row - 1]
        
        guard isLegacy(contact: contato) else {
            let alert = UIAlertController(title: "Você tocou em", message: "\(contato.name)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        let alert = UIAlertController(title: "Atenção", message:"Você tocou no contato sorteado", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}
