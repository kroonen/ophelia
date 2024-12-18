//
//  MessageRow.swift
//  ophelia
//
//  Created by rob on 2024-11-27.
//

import SwiftUI
import MarkdownUI

struct MessageRow: View {
    @ObservedObject var message: MutableMessage
    let appSettings: AppSettings
    @Environment(\.colorScheme) private var colorScheme

    private var isDarkMode: Bool {
        colorScheme == .dark
    }

    var body: some View {
        VStack(alignment: message.isUser ? .trailing : .leading, spacing: 4) {
            // Message header with timestamp and metadata
            messageHeader
            
            // Message content with appropriate styling
            HStack(alignment: .bottom, spacing: 12) {
                if message.isUser {
                    Spacer(minLength: 60)
                    userMessageContent
                } else {
                    assistantMessageContent
                    Spacer(minLength: 60)
                }
            }
        }
        .padding(.horizontal, 16)
        .animation(.easeInOut(duration: 0.2), value: message.text) // Smooth animation
    }
    
    // MARK: - Message Header
    private var messageHeader: some View {
        HStack {
            if message.isUser {
                Text("You")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Text(message.timestamp, style: .time)
                    .font(.caption)
                    .foregroundColor(.secondary)
            } else {
                let providerName = message.originProvider ?? appSettings.selectedProvider.rawValue
                let modelName = message.originModel ?? appSettings.selectedModel.name
                Text("\(providerName) - \(modelName)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Text(message.timestamp, style: .time)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }

    // MARK: - User Message Content
    private var userMessageContent: some View {
        Markdown(message.text)
            .markdownTextStyle {
                ForegroundColor(Color.white)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.Theme.accentGradient(isDarkMode: isDarkMode))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: Color.black.opacity(0.05), radius: 8, y: 2)
    }

    // MARK: - Assistant Message Content
    private var assistantMessageContent: some View {
        Markdown(message.text)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.Theme.bubbleBackground(isDarkMode: isDarkMode))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.5), lineWidth: 1)
            )
    }
}
