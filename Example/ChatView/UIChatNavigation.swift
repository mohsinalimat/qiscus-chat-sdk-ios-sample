//
//  ChatTitleView.swift
//  QiscusUI
//
//  Created by Qiscus on 25/10/18.
//

import UIKit
import QiscusCore

class UIChatNavigation: UIView {
    var contentsView            : UIView!
    // ui component
    /// UILabel title,
    @IBOutlet weak var labelTitle: UILabel!
    /// UILabel subtitle
    @IBOutlet weak var labelSubtitle: UILabel!
    /// UIImageView room avatar
    @IBOutlet weak var imageViewAvatar: UIImageView!
    
    var room: RoomModel? {
        set {
            self._room = newValue
            if let data = newValue { present(room: data) } // bind data only
        }
        get {
            return self._room
        }
    }
    private var _room : RoomModel? = nil
    
    override var intrinsicContentSize: CGSize {
        return UIView.layoutFittingExpandedSize
    }
    
    // If someone is to initialize a UIChatInput in code
    override init(frame: CGRect) {
        // For use in code
        super.init(frame: frame)
        let nib = UINib(nibName: "UIChatNavigation", bundle: nil)
        commonInit(nib: nib)
    }
    
    // If someone is to initalize a UIChatInput in Storyboard setting the Custom Class of a UIView
    required init?(coder aDecoder: NSCoder) {
        // For use in Interface Builder
        super.init(coder: aDecoder)
        let nib = UINib(nibName: "UIChatNavigation", bundle: nil)
        commonInit(nib: nib)
    }
    
    func commonInit(nib: UINib) {
        self.contentsView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        // 2. Adding the 'contentView' to self (self represents the instance of a WeatherView which is a 'UIView').
        addSubview(contentsView)
        
        // 3. Setting this false allows us to set our constraints on the contentView programtically
        contentsView.translatesAutoresizingMaskIntoConstraints = false
        
        // 4. Setting the constraints programatically
        contentsView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentsView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        contentsView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        contentsView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        self.autoresizingMask  = (UIView.AutoresizingMask.flexibleWidth)
        self.setupUI()
    }
    
    private func setupUI() {
        // default ui
        if self.imageViewAvatar != nil {
            self.imageViewAvatar.widthAnchor.constraint(equalToConstant: 30).isActive = true
            self.imageViewAvatar.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            print("cek height ini =\(self.contentsView.frame.height)")
            self.imageViewAvatar.layer.cornerRadius = self.imageViewAvatar.frame.height/2
        }
    }
    
    func present(room: RoomModel) {
        // title value
        self.labelTitle.text = room.name
        self.imageViewAvatar.af_setImage(withURL: room.avatarUrl ?? URL(string: "http://")!)
        if room.type == .group {
            self.labelSubtitle.text = getParticipant(room: room)
        }else {
            self.labelSubtitle.text = ""
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.imageViewAvatar != nil {
            self.imageViewAvatar.layer.cornerRadius = self.imageViewAvatar.frame.height/2
        }
    }
    
}

extension UIChatNavigation {
    func getParticipant(room: RoomModel) -> String {
        var result = ""
        guard let participants = room.participants else { return result }
        for m in participants {
            if result.isEmpty {
                result = m.username
            }else {
                result = result + ", \(m.username)"
            }
        }
        return result
    }
}
