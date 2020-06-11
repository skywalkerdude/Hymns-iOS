import SwiftUI

struct SelectLabelView: View {
    @Binding var tagColor: TagColor
    @State var blueButton = false
    @State var greenButton = false
    @State var yellowButton = false
    @State var redButton = false

    var body: some View {
        VStack {
            HStack {
                Text("Select a color").font(.body).fontWeight(.bold)
                Spacer()
            }
            HStack {
                Button(action: {
                    self.tagColor = .blue
                    self.resetForBlue()
                }, label: {
                    Text("blue").font(.body).fontWeight(self.blueButton ? .bold : .none)
                }).padding(6)
                    .background(Color(UIColor(red: 2/255, green: 118/255, blue: 254/255, alpha: 0.2)))
                    .foregroundColor(.blue)
                    .cornerRadius(13)

                Button(action: {
                    self.tagColor = .green
                    self.resetForGreen()
                }, label: {
                    Text("green").font(.body).fontWeight(self.greenButton ? .bold : .none)
                }).padding(6)
                    .background(Color(UIColor(red: 80/255, green: 227/255, blue: 194/255, alpha: 0.2)))
                    .foregroundColor(Color(UIColor(red: 35/255, green: 190/255, blue: 155/255, alpha: 1.0)))
                    .cornerRadius(13)

                Button(action: {
                    self.tagColor = .yellow
                    self.resetForYellow()
                }, label: {
                    Text("yellow").font(.body).fontWeight(self.yellowButton ? .bold : .none)
                }).padding(6)
                    .background(Color(UIColor(red: 255/255, green: 209/255, blue: 0/255, alpha: 0.2)))
                    .foregroundColor(Color(UIColor(red: 176/255, green: 146/255, blue: 7/255, alpha: 1.0)))
                    .cornerRadius(13)

                Button(action: {
                    self.tagColor = .red
                    self.resetForRed()
                }, label: {
                    Text("red").font(.body).fontWeight(self.redButton ? .bold : .none)
                }).padding(6)
                    .background(Color(UIColor(red: 255/255, green: 0, blue: 31/255, alpha: 0.2)))
                    .foregroundColor(Color(UIColor(red: 255/255, green: 0, blue: 31/255, alpha: 0.78)))
                    .cornerRadius(13)
                Spacer()
            }.padding(.top)
        }
    }

    private func resetForBlue() {
        self.greenButton = false
        self.redButton = false
        self.yellowButton = false
        self.blueButton.toggle()
    }

    private func resetForGreen() {
        self.blueButton = false
        self.redButton = false
        self.yellowButton = false
        self.greenButton.toggle()

    }

    private func resetForYellow() {
        self.blueButton = false
        self.greenButton = false
        self.redButton = false
        self.yellowButton.toggle()

    }

    private func resetForRed() {
        self.blueButton = false
        self.greenButton = false
        self.yellowButton = false
        self.redButton.toggle()
    }
}

struct SelectLabelView_Previews: PreviewProvider {
    static var previews: some View {
        SelectLabelView(tagColor: .constant(.blue))
    }
}
