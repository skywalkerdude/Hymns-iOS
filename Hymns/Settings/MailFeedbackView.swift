import SwiftUI
import UIKit
import MessageUI

// https://stackoverflow.com/questions/56784722/swiftui-send-email
struct MailFeedbackView: UIViewControllerRepresentable {

    @Environment(\.presentationMode) var presentation
    @Binding var result: Result<MFMailComposeResult, Error>?

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {

        @Binding var presentation: PresentationMode
        @Binding var result: Result<MFMailComposeResult, Error>?

        init(presentation: Binding<PresentationMode>,
             result: Binding<Result<MFMailComposeResult, Error>?>) {
            _presentation = presentation
            _result = result
        }

        func mailComposeController(_ controller: MFMailComposeViewController,
                                   didFinishWith result: MFMailComposeResult,
                                   error: Error?) {
            defer {
                $presentation.wrappedValue.dismiss()
            }
            guard error == nil else {
                self.result = .failure(error!)
                return
            }
            self.result = .success(result)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(presentation: presentation,
                           result: $result)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<MailFeedbackView>) -> MFMailComposeViewController {
        let mailVC = MFMailComposeViewController()
        let randomIssueNum = Int.random(in: 1000000000...9999999999)
        mailVC.setToRecipients(["hymnalappfeedback@gmail.com"])
        mailVC.setSubject("Hymnal App Feedback # \(randomIssueNum)")
        mailVC.mailComposeDelegate = context.coordinator
        return mailVC
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController,
                                context: UIViewControllerRepresentableContext<MailFeedbackView>) {
    }
}
