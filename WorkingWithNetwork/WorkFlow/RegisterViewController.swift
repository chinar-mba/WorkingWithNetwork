//
//  RegisterViewController.swift
//  WorkingWithNetwork
//
//  Created by Chinar on 17/2/24.
//

import UIKit

class RegisterViewController: UIViewController {
    
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
    
    private lazy var passwordTextField: UITextField = {
        let view = UITextField()
        view.layer.cornerRadius = 10
        view.placeholder = "Password"
        view.isSecureTextEntry = false
        view.layer.borderColor = UIColor.blue.cgColor
        view.layer.borderWidth = 1.0
        view.autocapitalizationType = .none
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var confirmPasswordTextField: UITextField = {
        let view = UITextField()
        view.layer.cornerRadius = 10
        view.placeholder = "Password"
        view.isSecureTextEntry = false
        view.layer.borderColor = UIColor.blue.cgColor
        view.layer.borderWidth = 1.0
        view.autocapitalizationType = .none
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var nameTextField: UITextField = {
        let view = UITextField()
        view.layer.cornerRadius = 10
        view.placeholder = "Name"
        view.keyboardType = .emailAddress
        view.autocapitalizationType = .none
        view.autocorrectionType = .no
        view.layer.borderColor = UIColor.blue.cgColor
        view.layer.borderWidth = 1.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var surnameTextField: UITextField = {
        let view = UITextField()
        view.layer.cornerRadius = 10
        view.placeholder = "Surname"
        view.keyboardType = .emailAddress
        view.autocapitalizationType = .none
        view.autocorrectionType = .no
        view.layer.borderColor = UIColor.blue.cgColor
        view.layer.borderWidth = 1.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var registerButton: UIButton = {
        let view = UIButton()
        view.layer.cornerRadius = 10
        view.setTitle("Register", for: .normal)
        view.backgroundColor = .blue
        view.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
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
        view.addSubview(passwordTextField)
        view.addSubview(confirmPasswordTextField)
        view.addSubview(nameTextField)
        view.addSubview(surnameTextField)
        view.addSubview(registerButton)
    }
    
    private func setupConstraints() {
        let padding: CGFloat = 20
        let textFieldHeight: CGFloat = 44
        
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            emailTextField.heightAnchor.constraint(equalToConstant: textFieldHeight),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: padding),
            passwordTextField.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: textFieldHeight),
            
            confirmPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: padding),
            confirmPasswordTextField.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),
            confirmPasswordTextField.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor),
            confirmPasswordTextField.heightAnchor.constraint(equalToConstant: textFieldHeight),
            
            nameTextField.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: padding),
            nameTextField.leadingAnchor.constraint(equalTo: confirmPasswordTextField.leadingAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: confirmPasswordTextField.trailingAnchor),
            nameTextField.heightAnchor.constraint(equalToConstant: textFieldHeight),
            
            surnameTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: padding),
            surnameTextField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            surnameTextField.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            surnameTextField.heightAnchor.constraint(equalToConstant: textFieldHeight),
            
            registerButton.topAnchor.constraint(equalTo: surnameTextField.bottomAnchor, constant: padding * 2),
            registerButton.leadingAnchor.constraint(equalTo: surnameTextField.leadingAnchor),
            registerButton.trailingAnchor.constraint(equalTo: surnameTextField.trailingAnchor),
            registerButton.heightAnchor.constraint(equalToConstant: textFieldHeight)
        ])
    }
    
    @objc private func registerButtonTapped() {
        postRegister()
    }
    
    private func postRegister() {
        let user = Auth(email: emailTextField.text ?? "", password: passwordTextField.text ?? "", confirmPassword: confirmPasswordTextField.text ?? "", firstName: nameTextField.text ?? "", lastName: surnameTextField.text ?? "")
        
        networkService.postRegister(user: user ) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let model):
                self.handleSuccess()
            case .failure(let error):
                self.handleError(error: error)
            }
        }
    }
    
    private func handleSuccess() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Success", message: "You have been registered successfully.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            
            let nextVC = EmailVerificationViewController()
            nextVC.modalPresentationStyle = .fullScreen
            self.present(nextVC, animated: true, completion: nil)
        }
    }

    private func handleError(error: Error) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
}
