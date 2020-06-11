import SwiftUI
import MessageUI

struct FeedbackView: View {

    @State var result: Result<MFMailComposeResult, Error>?
    @State var isShowingMailView = false

    var body: some View {
        Button(action: {
            self.isShowingMailView.toggle()
        }, label: {
            Text("Send Feedback").font(.callout)
        }).padding().foregroundColor(.primary)
            .disabled(!MFMailComposeViewController.canSendMail())
            .sheet(isPresented: $isShowingMailView) {
                MailFeedbackView(result: self.$result)
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        FeedbackView().toPreviews()
    }
}
#endif
