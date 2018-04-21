//
//  OptionsViewController.swift
//  HackerNews
//
//  Created by Mihail Cristian Dumitru on 11/14/16.
//  Copyright © 2016 Null. All rights reserved.
//

import AsyncDisplayKit

class OptionsViewController: BaseViewController {

    // MARK: - IBOutlets

    var tableView: OptionSelectTableView!
    var optionsView = OptionSelectView()

    // MARK: - Properties

    var delegate: OptionSelectViewDelegate?

    // MARK: - Lifecycle

    init() {
        super.init(node: self.optionsView)

        self.tableView = self.optionsView.tableView

		self.setupTransition()
    }

    init(delegate: OptionSelectViewDelegate) {
        super.init(node: self.optionsView)

        self.tableView = self.optionsView.tableView
        self.delegate = delegate

        self.setupTransition()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.setupTransition()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setup()
    }

    // MARK: - Setup Helpers

    func setup() {
        self.setupTableView()
        self.setupTheme()
    }

    func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }

    func setupTransition() {
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
    }

    // MARK: - Helpers

    func hide(animated: Bool = true, completion: (() -> Void)? = nil) {
        self.dismiss(animated: animated, completion: completion)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.hide()
    }

}

// MARK: - ASTableDataSource, ASTableDelegate

extension OptionsViewController: ASTableDataSource, ASTableDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.delegate?.numberOfSections(in: self) ?? 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.delegate?.optionSelectView(optionSelectView: self, viewForHeaderInSection: section)
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.delegate?.optionSelectView(optionSelectView: self, heightForHeaderInSection: section) ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.delegate?.optionSelectView(optionSelectView: self, numberOfItemsInSection: section) ?? 0)
    }

    func tableView(_ tableView: ASTableView, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return self.delegate?.optionSelectView(optionSelectView: self, nodeBlockForRowAt: indexPath) ?? {
            return ASCellNode()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)

        self.hide(animated: true) { [weak self] in
            if let weakSelf = self {
                weakSelf.delegate?.optionSelectView(optionSelectView: weakSelf, didSelectItemAtIndexPath: indexPath)
            }
        }
    }
}
