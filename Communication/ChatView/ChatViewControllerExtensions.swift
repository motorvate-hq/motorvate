//
//  ChatViewControllerExtensions.swift
//  Motorvate
//
//  Created by Nikita Benin on 19.04.2022.
//  Copyright © 2022 motorvate. All rights reserved.
//

import Foundation
import MessageKit
import SafariServices

// MARK: - SFSafariViewControllerDelegate
extension ChatViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - ConnectBankPopupDelegate
extension ChatViewController: ConnectBankPopupDelegate {
    func showSafariController(url: URL) {
        let vc = WebController(url: url)
        if presentedViewController != nil {
            presentedViewController?.dismiss(animated: false, completion: { [weak self] in
                self?.present(vc, animated: true)
            })
        } else {
            present(vc, animated: true)
        }
    }
}

// MARK: - MessagesDisplayDelegate
extension ChatViewController: MessagesDisplayDelegate {
    func enabledDetectors(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> [DetectorType] {
        return [.url]
    }

    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        if message.sender.senderId == currentSender().senderId {
            return .white
        } else {
            return UIColor(red: 27 / 255, green: 52 / 255, blue: 206 / 255, alpha: 1)
        }
    }

    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        if message.sender.senderId == currentSender().senderId {
            return .black
        } else {
            return .white
        }
    }

    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let isOutgoing: Bool = message.sender.senderId == currentSender().senderId
        return isOutgoing ? .bubbleOutline(UIColor(red: 223 / 255, green: 223 / 255, blue: 223 / 255, alpha: 1)) : .bubble
    }
}

extension ChatViewController: MessagesLayoutDelegate {
    func messagePadding(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIEdgeInsets {
        return UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
    }
}

extension ChatViewController: MessageCellDelegate {
    func headerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        let size = CGSize(width: messagesCollectionView.frame.width, height: 66)
          if section == 0 {
            return size
          }

          let currentIndexPath = IndexPath(row: 0, section: section)
          let lastIndexPath = IndexPath(row: 0, section: section - 1)
          let lastMessage = messageForItem(at: lastIndexPath, in: messagesCollectionView)
          let currentMessage = messageForItem(at: currentIndexPath, in: messagesCollectionView)

          if currentMessage.sentDate.isInSameDayOf(date: lastMessage.sentDate) {
            return .zero
          }

          return size
    }
    
    func messageHeaderView(for indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageReusableView {
        let messsage = messageForItem(at: indexPath, in: messagesCollectionView)
        let header = messagesCollectionView.dequeueReusableHeaderView(MessageDateReusableView.self, for: indexPath)
        header.setDate(date: messsage.sentDate)
        return header
    }
}
