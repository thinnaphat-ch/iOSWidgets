//
//  PrimaryTextField.swift
//  ComponentTest
//
//  Created by Sitthorn Ch on 18/2/2564 BE.
//

import Foundation
import UIKit

@IBDesignable
public class PrimaryTextField: UITextField, PrimaryTextInput {
    
    var titleLabel = UILabel()
    var helpingTextLabel = UILabel()
    var helpingTextIconImageView = UIImageView()
    var titleCenterConstraint = NSLayoutConstraint()
    var titleTopConstraint = NSLayoutConstraint()
    var titleLeftMargin = NSLayoutConstraint()
    var titleRightMargin = NSLayoutConstraint()
    public var heightConstraint = NSLayoutConstraint()
    var iconImageView = UIImageView()
    public var actionButton = UIButton()
    public var inputState: PrimaryInputState = .idle
    var tempPlaceholder: String?
    var tempHelpingText: String?
    var layerShape = CAShapeLayer()
    var helpingTextStackView: UIStackView?
    public var descriptionLabel = UILabel()
    var countingLabel = UILabel()
    var borderLine = CAShapeLayer()
    var currentHeight: CGFloat = 0
    internal var initialHeight: CGFloat = 0
    
    public var error: PrimaryError? {
        didSet {
            if let error = error {
                inputState = .error
                helpingText = error.description ?? ""
            }else {
                inputState = isFirstResponder ? (hasTextInput ? .typing : .focus) : (hasTextInput ? .typed : .idle)
                if isEnabled.revert {
                    inputState = .disabled
                }
                helpingText = tempHelpingText ?? ""
            }
            updateLayout()
            heightConstraint.constant = realHeight
        }
    }
    
    public override var placeholder: String? {
        didSet {
            tempPlaceholder = placeholder?.isNotEmpty ?? false ? placeholder : tempPlaceholder
            setPlaceHolder(input: tempPlaceholder)
        }
    }
    
    public override var text: String? {
        didSet {
            layoutSubviews()
        }
    }
    
    @IBInspectable public var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    @IBInspectable public var helpingText: String = "" {
        didSet {
            createHelpingText()
            setHelpingText(helpingText)
            heightConstraint.constant = realHeight
        }
    }
    
    @IBInspectable public var helpingTextIcon: UIImage? {
        didSet {
            createHelpingText()
            helpingTextIconImageView.image = helpingTextIcon
            heightConstraint.constant = realHeight
        }
    }
    
    public override var isEnabled: Bool {
        didSet {
            switch isEnabled {
            case true:
                inputState = hasTextInput ? .typed : .idle
            case false:
                inputState = .disabled
            }
            updateLayout()
        }
    }
    
    @IBInspectable public var maximumLength = 100
    @IBInspectable public var icon: UIImage? {
        didSet {
            createIconImageView()
            iconImageView.image = icon
        }
    }
    
    @IBInspectable public var actionIcon: UIImage? {
        didSet {
            createActionButton()
            actionButton.setImage(actionIcon, for: .normal)
        }
    }
    
    @IBInspectable public var actionIconSelected: UIImage? {
        didSet {
            createActionButton()
            actionButton.setImage(actionIconSelected, for: .selected)
        }
    }
    
    public var action: ((PrimaryTextField) -> Void)?
    
    @IBInspectable public var inputAccessory: Bool = true {
        didSet{
            self.inputAccessoryView = inputAccessory ? createInputAccessories() : nil
        }
    }
    
    @IBInspectable public var countingCharacter: Bool = false {
        didSet {
            createCountingText()
        }
    }
    @IBInspectable public var descriptionText: String? {
        didSet {
            createDescriptionLabel()
            setDescriptionText(descriptionText)
            heightConstraint.constant = realHeight
        }
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
        
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        if error != nil {
            inputState = .error
        }
        if isEnabled.revert {
            inputState = .disabled
        }
        invalidateIntrinsicContentSize()
        updateLayout()
        resizeBound()
    }
    
    public override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        guard error == nil else {
            return true
        }
        inputState = hasTextInput ? .typing : .focus
        return true
    }
    
    public override func resignFirstResponder() -> Bool {
        super.resignFirstResponder()
        guard error == nil else {
            return true
        }
        inputState = hasTextInput ? .typed : .idle
        return true
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        
        return bounds.inset(by: inputInset)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: inputInset)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: inputInset)
    }
    
    func notifyTextFieldIsEditing(_ notification: Notification) {
        guard let textField = notification.object as? PrimaryTextField, textField == self else {
            return
        }
        textField.updateCountingCharacter(text: textField.text)
    }
    
    @objc func keyboardDoneAction() {
        _ = self.resignFirstResponder()
    }
    
}
