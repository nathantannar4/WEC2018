//
//  Stylesheet.swift
//  WEC2018
//
//  Created by Nathan Tannar on 1/1/18.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit

enum Stylesheet {
    
    private static var titleFont: UIFont {
        return .boldSystemFont(ofSize: 28)
    }
    
    private static var subtitleFont: UIFont {
        return .systemFont(ofSize: 17, weight: .semibold)
    }
    
    private static var descriptionFont: UIFont {
        return .systemFont(ofSize: 14, weight: .regular)
    }
    
    private static var buttonFont: UIFont {
        return .systemFont(ofSize: 14, weight: .regular)
    }
    
    private static var footnoteFont: UIFont {
        return .systemFont(ofSize: 12, weight: .medium)
    }
    
    enum ViewController {
        
        static let view = Style<UIView> {
            $0.backgroundColor = .groupTableViewBackground
        }
        
        static let navigationBar = Style<UINavigationBar> {
            $0.barTintColor = .primaryColor
            $0.tintColor = .secondaryColor
            $0.isTranslucent = false
            $0.titleTextAttributes = [
                NSAttributedStringKey.font : titleFont.withSize(18),
                NSAttributedStringKey.foregroundColor : UIColor.white
            ]
            if #available(iOS 11.0, *) {
                $0.prefersLargeTitles = true
                $0.largeTitleTextAttributes = [
                    NSAttributedStringKey.font : titleFont,
                    NSAttributedStringKey.foregroundColor : UIColor.white
                ]
            }
        }
        
    }
    
    enum Global {
        
        static let shadow = Style<UIView> {
            $0.layer.shadowColor = UIColor.darkGray.cgColor
            $0.layer.shadowOpacity = 0.3
            $0.layer.shadowRadius = 2
            $0.layer.shadowOffset = CGSize(width: 0, height: 2)
        }
        
    }
    
    enum Labels {
        
        static let title = Style<UILabel> {
            $0.font = titleFont.withSize(18)
            $0.numberOfLines = 0
        }
        
        static let subtitle = Style<UILabel> {
            $0.font = subtitleFont
            $0.textColor = .darkGray
            $0.numberOfLines = 0
        }
        
        static let description = Style<UILabel> {
            $0.font = descriptionFont
            $0.textColor = .black
            $0.numberOfLines = 0
        }
        
    }
    
}
