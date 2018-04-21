//
//  HNPostViewController.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 6/24/17.
//  Copyright © 2017 Null. All rights reserved.
//

import AsyncDisplayKit

class HNPostViewController: BaseViewController {

    // MARK: - IBOutlets

    var tableView = HNTableNode()

    // MARK: - Lifecycle

    init() {
        super.init(node: self.tableView)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.registerForKeyboardNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Setup Helpers

    func setup() {
        self.setupTableView()

        self.setupNavigationItem()
    }

    func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }

    func setupNavigationItem() {
        self.navigationItem.set(leftButtonIcon: .ion_close, target: self, action: #selector(self.onCloseButtonPressed))
        self.navigationItem.set(rightButtonIcon: .ion_checkmark_round, target: self, action: #selector(self.onPostButtonPressed))
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.onKeyboardDidShow(notification:)), name: .UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.onKeyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
    }

    // MARK: - Helpers

    func onCloseButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }

    func onPostButtonPressed() {
    }

    func onKeyboardDidShow(notification: Notification) {
    }

    func onKeyboardWillHide(notification: Notification) {
    }

}

// MARK: - ASTableDataSource, ASTableDelegate

extension HNPostViewController: ASTableDataSource, ASTableDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: ASTableView, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {
            return ASCellNode()
        }
    }

}
