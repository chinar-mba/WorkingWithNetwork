//
//  AuthViewController.swift
//  WorkingWithNetwork
//
//  Created by Chinar on 17/2/24.
//

import UIKit

class AuthViewController: UIViewController {
    
    let networkService = NetworkService()
    
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
    
    private lazy var signInButton: UIButton = {
        let view = UIButton()
        view.layer.cornerRadius = 10
        view.setTitle("Sign In", for: .normal)
        view.backgroundColor = .blue
        view.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
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
        view.addSubview(signInButton)
        view.addSubview(registerButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emailTextField.widthAnchor.constraint(equalToConstant: 320),
            emailTextField.heightAnchor.constraint(equalToConstant: 40),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.widthAnchor.constraint(equalToConstant: 320),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40),
            
            signInButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signInButton.widthAnchor.constraint(equalToConstant: 320),
            signInButton.heightAnchor.constraint(equalToConstant: 40),
            
            registerButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 20),
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerButton.widthAnchor.constraint(equalToConstant: 320),
            registerButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc private func signInButtonTapped() {
        postLogin()
    }
    private func postLogin() {
        let login = LoginDetail(email: emailTextField.text ?? "", password: passwordTextField.text ?? "")
        networkService.postLogin(login: login) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let model):
                print("Success")
                DispatchQueue.main.async {
                    self.nextVC()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func nextVC () {
        let nextVC = MainViewController()
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: true, completion: nil)
    }
    
    @objc private func registerButtonTapped() {
        let registerVC = RegisterViewController()
        navigationController?.pushViewController(registerVC, animated: true)
    }
}
