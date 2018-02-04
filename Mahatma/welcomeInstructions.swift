import UIKit

class welcomeInstructions: UIVisualEffectView {
    
    var text: String? {
        didSet {
            label.text = text
        }
    }
    
    let label: UILabel = UILabel()
    let label2: UILabel = UILabel()
    
    init(text: String, text2: String) {
        self.label.text = text
        self.label2.text = text
        let blurEffect = UIBlurEffect(style: .light)
        super.init(effect: blurEffect)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.text = ""
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func setup() {
        contentView.addSubview(label)
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if let superview = self.superview {
            
            let width = superview.frame.size.width / 1.0
            let height: CGFloat = 50.0
            self.frame = CGRect(x: superview.frame.size.width / 2 - width / 2,
                                y: superview.frame.height / 2 - height / 2 - 150,
                                width: width,
                                height: height)
            //label.text = text
            label.textAlignment = NSTextAlignment.center
            label.frame = CGRect(x: 5,
                                 y: 0,
                                 width: width - 15,
                                 height: height)
            label.textColor = UIColor.gray
            label.font = UIFont.boldSystemFont(ofSize: 16)
            
            //TODO: MOVE LABEL TWO SO ITS SHOWN
            //label2.text = text
            label2.textAlignment = NSTextAlignment.center
            label2.frame = CGRect(x: 5,
                                 y: 0+height,
                                 width: width - 15,
                                 height: height)
            label2.textColor = UIColor.gray
            label2.font = UIFont.boldSystemFont(ofSize: 16)
        }
    }
    
    func show() {
        self.isHidden = false
    }
    
    func hide() {
        self.isHidden = true
    }
}

