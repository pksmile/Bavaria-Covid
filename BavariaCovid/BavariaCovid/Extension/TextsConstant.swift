//
//  TextsConstant.swift
//  BavariaCovid
//
//  Created by PRAKASH on 12/20/20.
//

import Foundation

struct BottomSheet {
    static let loadData = NSLocalizedString("loadData", comment: "count down title")
}

//Alert
struct AlertMsg {
    static let headerErrorMessage = NSLocalizedString("err", comment: "")
    static let DescServerErrMsg = NSLocalizedString("serverError", comment: "")
    static let actionOkay = NSLocalizedString("okay", comment: "")
}

//Covid Rules
struct CovidRulesMsg {
    static let rulesMsgGreen = NSLocalizedString("greenRules", comment: "")
    static let rulesMsgYellow = NSLocalizedString("yellowRules", comment: "")
    static let rulesMsgRed = NSLocalizedString("redRules", comment: "")
    static let rulesMsgDarkRed = NSLocalizedString("darkGreenRules", comment: "")
}

//Notification Title
struct Notification {
    static let notificationTitle = NSLocalizedString("notificationTitle", comment: "count down title")
}

//Alert Messages
struct AlertMessage {
    static let allowLocationAccessTitle = NSLocalizedString("allowLocationAccessTitle", comment: "Allow Location access.")
    static let allowLocationAccessMessage = NSLocalizedString("allowLocationAccessMessage", comment: "Allow Location access messages.")
    static let settingsTitle = NSLocalizedString("settingsTitle", comment: "Settings")
    static let skipTitle = NSLocalizedString("skipTitle", comment: "Skip")
}
