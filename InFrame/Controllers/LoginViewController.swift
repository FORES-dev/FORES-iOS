//
//  LoginViewController.swift
//  InFrame
//
//  Created by 김유진 on 2021/09/14.
//

import UIKit
import SnapKit
import Then
import Alamofire

class LoginViewController: UIViewController {
    //MARK: - Properties
    private let logInTitleLabel = UILabel().then{
        $0.text = "LogIn"
        $0.dynamicFont(fontSize: 30, currentFontName: "CarterOne")
        $0.updateGradientTextColor_horizontal(gradientColors: [UIColor.rgb(red: 126, green: 152, blue: 212), UIColor.rgb(red: 251, green: 186, blue: 200)])
    }
    
    private let emailInputView = InputView().then{
        $0.dataSetting(titleText: "Email", placeholderText: "이메일을 입력해주세요.")
    }

    private let passwordInputview = InputView().then{
        $0.dataSetting(titleText: "Password", placeholderText: "비밀번호를 입력해주세요.")
    }
    
    private let forgetPasswordButton = UIButton().then{
        $0.setTitle("비밀번호를 잊으셨나요?", for: .normal)
        $0.setTitleColor(UIColor(red: 178/255, green: 178/255, blue: 178/255, alpha: 1), for: .normal)
        $0.dynamicFont(fontSize: 10, currentFontName: "AppleSDGothicNeo-Medium")
        $0.addTarget(self, action: #selector(forgetButtonClicked(sender:)), for: .touchUpInside)
    }
    
    private let logInButton = GradientButton().then{
        $0.dataSetting(buttonText: "로그인하기")
        $0.addTarget(self, action: #selector(logInButtonClicked(sender:)), for: .touchUpInside)
    }
    
    private let noAccountButton = UIButton().then{
        $0.setTitle("계정이 없으신가요?", for: .normal)
        $0.dynamicFont(fontSize: 11, currentFontName: "AppleSDGothicNeo-Bold")
        $0.setTitleColor(UIColor.rgb(red: 178, green: 178, blue: 178), for: .normal)
        $0.addTarget(self, action: #selector(noAccountButtonClicked(sender:)), for: .touchUpInside)
    }
    
    //MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: - Helpers
    private func configureUI(){
        view.backgroundColor = .white
        
        addView()
        location()
        registerForKeyboardNotification()
    }
    
    // MARK: - location
    private func location(){
        logInTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(self.view.frame.height/4.65)
            make.left.equalToSuperview().offset(self.view.frame.width/5.75)
        }
        emailInputView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.equalTo(logInTitleLabel.snp.bottom).offset(self.view.frame.height/15.03)
            make.height.equalToSuperview().dividedBy(16)
        }
        passwordInputview.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.equalTo(emailInputView.snp.bottom).offset(self.view.frame.height/35.3)
            make.height.equalToSuperview().dividedBy(16)
        }
        forgetPasswordButton.snp.makeConstraints { make in
            make.top.equalTo(passwordInputview.snp.bottom)
            make.left.equalToSuperview().offset(self.view.frame.width/6.46)
        }
        logInButton.snp.makeConstraints { make in
            make.left.equalTo(forgetPasswordButton)
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().dividedBy(19.8)
            make.top.equalTo(forgetPasswordButton.snp.bottom).offset(self.view.frame.height/19.8)
        }
        noAccountButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-self.view.frame.height/11.94)
            make.centerX.equalToSuperview()
        }
        emailInputView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.equalTo(logInTitleLabel.snp.bottom).offset(self.view.frame.height/15.03)
            make.height.equalToSuperview().dividedBy(16)
        }
    }
    
    // MARK: - addView
    private func addView(){
        [logInTitleLabel, emailInputView, passwordInputview, forgetPasswordButton, logInButton, noAccountButton].forEach { view.addSubview($0) }
    }
    
    // MARK: - Selecters
    @objc func logInButtonClicked(sender:UIButton){
        if isValidEmail(email: emailInputView.getInfo()) == true{
            if isValidPassword(password: passwordInputview.getInfo()) == true{
                let nextVC = MainViewController()
                self.navigationController?.pushViewController(nextVC, animated: true)
                
            }else{ passwordInputview.shakeView(passwordInputview) }
        }else{ emailInputView.shakeView(emailInputView) }
    }
    
    @objc func noAccountButtonClicked(sender:UIButton){
        let nextVC = SignUpViewController()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func forgetButtonClicked(sender:UIButton){
        let nextVC = FindPasswardEmailViewController()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func keyBoardShow(notification: NSNotification){
        UIView.animate(withDuration: 0.3) {
            self.logInTitleLabel.snp.remakeConstraints { make in
                make.top.equalToSuperview().offset(self.view.frame.height/8)
                make.left.equalToSuperview().offset(self.view.frame.width/5.75)
            }
            
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardHide(notification: NSNotification){
        UIView.animate(withDuration: 0.3) {
            self.logInTitleLabel.snp.remakeConstraints { make in
                make.top.equalToSuperview().offset(self.view.frame.height/4.65)
                make.left.equalToSuperview().offset(self.view.frame.width/5.75)
            }
            
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - registerForKeyboardNotification
    private func registerForKeyboardNotification(){
         NotificationCenter.default.addObserver(self, selector: #selector(keyBoardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - isValidEmail
    private func isValidEmail(email: String?) -> Bool {
        guard email != nil else { return false }
        
        let idRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let pred = NSPredicate(format:"SELF MATCHES %@", idRegEx)
        return pred.evaluate(with: email)
    }
    
    // MARK: - isValidPassword
    private func isValidPassword(password: String?) -> Bool {
        guard password != nil else { return false }
            
        let passwordRegEx = ("(?=.*[A-Za-z~!@#$%^&*])(?=.*[0-9]).{8,}")
        let pred = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return pred.evaluate(with: password)
    }
}
