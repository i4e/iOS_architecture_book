//
//  ViewController.swift
//  OriginalMVCSample
//
//  Created by Jun Ishii on 2019/02/05.
//  Copyright © 2019年 Jun Ishii. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private lazy var myView = View()
    
    override func loadView() {
        view = myView
        view.backgroundColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myView.myModel = Model()
    }

}


class Model {
    let notificationCenter = NotificationCenter()
    
    private(set) var count = 0 {
        didSet {
            notificationCenter.post(name: .init(rawValue: "count"),
                                object: nil,
                                userInfo: ["count": count])
        }
    }
    
    func countDown() {
        count -= 1
    }
    
    func countUp() {
        count += 1
    }
    
}

class Controller {
    weak var myModel: Model?
    
    required init() {
        
    }
    
    @objc func onMinusTapped() {
        myModel?.countDown()
    }
    
    @objc func onPlusTapped() {
        myModel?.countUp()
    }
    
}

class View: UIView {
    
    let label = UILabel()
    let minusButton = UIButton()
    let plusButton = UIButton()
    
    var dafaultControllerClass: Controller.Type = Controller.self
    private var myController: Controller?
    
    var myModel: Model? {
        didSet {
           registerModel()
        }
    }
    
    deinit {
        myModel?.notificationCenter.removeObserver(self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setSubViews()
        setLayout()
    }
    

    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    private func setSubViews() {
    
        addSubview(label)
        addSubview(minusButton)
        addSubview(plusButton)
    
        label.textAlignment = .center
    
        label.backgroundColor = .blue
        minusButton.backgroundColor = .red
        plusButton.backgroundColor = .green
    
        minusButton.setTitle("-1", for: .normal)
        plusButton.setTitle("+1", for: .normal)
    
    }
    
    private func setLayout() {
        
        label.translatesAutoresizingMaskIntoConstraints = false
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        minusButton.translatesAutoresizingMaskIntoConstraints = false
        
        label.topAnchor.constraint(equalTo: topAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        label.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: minusButton.topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: plusButton.topAnchor).isActive = true
        label.heightAnchor.constraint(equalTo: minusButton.heightAnchor).isActive = true
        label.heightAnchor.constraint(equalTo: plusButton.heightAnchor).isActive = true
        minusButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        plusButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        minusButton.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        minusButton.rightAnchor.constraint(equalTo: plusButton.leftAnchor).isActive = true
        plusButton.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        minusButton.widthAnchor.constraint(equalTo: plusButton.widthAnchor).isActive = true
        
    }
    
    private func registerModel() {
        
        guard let model = myModel else { return }
        
        let controller = dafaultControllerClass.init()
        controller.myModel = model
        myController = controller
        
        label.text = model.count.description
        
        minusButton.addTarget(controller, action: #selector(Controller.onMinusTapped), for: .touchUpInside)
        plusButton.addTarget(controller, action: #selector(Controller.onPlusTapped), for: .touchUpInside)
        
        model.notificationCenter.addObserver(forName: .init(rawValue: "count"),
                                             object: nil,
                                             queue: nil,
                                             using: { [unowned self] notification in
                                                if let count = notification.userInfo?["count"] as? Int {
                                                    self.label.text = count.description
                                                }
        })
        
    }
    
}


