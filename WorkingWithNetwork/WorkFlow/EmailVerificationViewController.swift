//
//  EmailVerificationViewController.swift
//  WorkingWithNetwork
//
//  Created by Chinar on 19/2/24.
//

import UIKit

class EmailVerificationViewController: UIViewController {
    
    private let networkService = NetworkService()
    
    private lazy var emailTextField: UITextField = {
        let view = UITextField()
        view.layer.cornerRadius = 10
        view.placeholder = "Email"
        view.keyboardType = .emailAddress
        view.autocapitalizationType = .none
        view.autocorrectionType = .no
        view.layer.borderColor = UIColor.blue.cgColor
        view.layer.borderWidth = 1.0
        view.autocapitalizationType = .none
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var codeTextField: UITextField = {
        let view = UITextField()
        view.layer.cornerRadius = 10
        view.placeholder = "Code"
        view.keyboardType = .emailAddress
        view.autocapitalizationType = .none
        view.autocorrectionType = .no
        view.layer.borderColor = UIColor.blue.cgColor
        view.layer.borderWidth = 1.0
        view.keyboardType = .numberPad
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var confirmButton: UIButton = {
        let view = UIButton()
        view.layer.cornerRadius = 10
        view.setTitle("Confirm", for: .normal)
        view.backgroundColor = .blue
        view.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        view.addSubview(emailTextField)
        view.addSubview(codeTextField)
        view.addSubview(confirmButton)
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            
            codeTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            codeTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            codeTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            codeTextField.heightAnchor.constraint(equalToConstant: 50),
            
            confirmButton.topAnchor.constraint(equalTo: codeTextField.bottomAnchor, constant: 20),
            confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            confirmButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func confirmButtonTapped() {
        patchEmailVerification()
    }
    
    private func patchEmailVerification() {
        guard let email = emailTextField.text, let code = codeTextField.text else {
               print("Email or code is empty")
               return
           }
        let emailVerification = EmailVerification(email: email, code: code)
            
            networkService.patchEmailVerification(emailCode: emailVerification) { [weak self] (result: Result<Void, Error>) in
                guard let self = self else { return }

                    switch result {
                    case .success:
                        DispatchQueue.main.async {
                            self.nextVC()
                        }
                    case .failure(let error):
                        print("Error verifying code: \(error)")
                    }
            }
        }
    
    private func nextVC() {
        let nextVC = AuthViewController()
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: true, completion: nil)
    }
}
