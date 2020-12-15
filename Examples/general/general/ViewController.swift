//
//  ViewController.swift
//  general
//
//  Created by George on 15.12.2020.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        title = "Main"
    }

    @IBAction private func plasticTap() {
        guard let navigation = navigationController else { return }
        CardOrderAddressRouter(navigationController: navigation) { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }.showWallettoEnterAddress(with: .plastic,
                                   address: CardOrderAddressModel(address: "pr. Marshala Zhukova",
                                                                  city: "Moscow",
                                                                  country: "Russia",
                                                                  zip: "123000"))
    }

    @IBAction private func virtualTap() {
        guard let navigation = navigationController else { return }
        CardOrderAddressRouter(navigationController: navigation) { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }.showWallettoEnterAddress(with: .virtual,
                                   address: CardOrderAddressModel(address: "pr. Marshala Zhukova",
                                                                  city: "Moscow",
                                                                  country: "Russia",
                                                                  zip: "123000"))
    }

}

