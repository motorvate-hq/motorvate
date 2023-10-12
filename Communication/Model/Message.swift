//
//  Message.swift
//  Motorvate
//
//  Created by Emmanuel on 9/6/19.
//  Copyright © 2019 motorvate. All rights reserved.
//

import MessageKit
import UIKit

public struct Message {
    // swiftlint:disable identifier_name
    public let id: String
    public let date: Date
    public let user: User
    public let kind: MessageKind

    private init(with kind: MessageKind, messageId: String, user: User, date: Date) {
        self.kind = kind
        self.id = messageId
        self.user = user
        self.date = date
    }

    init(text: String, messageId: String, user: User, date: Date) {
        self.init(with: .text(text), messageId: messageId, user: user, date: date)
    }

    init(image: UIImage, messageId: String, user: User, date: Date) {
        let mediaItem = ImageMediaItem(image: image)
        self.init(with: .photo(mediaItem), messageId: messageId, user: user, date: date)
    }
}

extension Message: MessageType {
    public var sender: SenderType {
        return user
    }

    public var messageId: String {
        return id
    }

    public var sentDate: Date {
        return date
    }
}
