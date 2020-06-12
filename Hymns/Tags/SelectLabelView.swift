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
                    Text("Blue").font(.body).fontWeight(self.blueButton ? .bold : .none)
                }).padding(10)
                    .background(TagColor.getBackColor("blue"))
                    .foregroundColor(TagColor.getFrontColor("blue"))
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.blue, lineWidth: self.blueButton ? 3 : 0)
                )

                Button(action: {
                    self.tagColor = .green
                    self.resetForGreen()
                }, label: {
                    Text("Green").font(.body).fontWeight(self.greenButton ? .bold : .none)
                }).padding(10)
                    .background(TagColor.getBackColor("green"))
                    .foregroundColor(TagColor.getFrontColor("green"))
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color(red: 35/255, green: 190/255, blue: 155/255, opacity: 1.0), lineWidth: self.greenButton ? 3 : 0))

                Button(action: {
                    self.tagColor = .yellow
                    self.resetForYellow()
                }, label: {
                    Text("Yellow").font(.body).fontWeight(self.yellowButton ? .bold : .none)
                }).padding(10)
                    .background(TagColor.getBackColor("yellow"))
                    .foregroundColor(TagColor.getFrontColor("yellow"))
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color(red: 176/255, green: 146/255, blue: 7/255, opacity: 1.0), lineWidth: self.yellowButton ? 3 : 0))

                Button(action: {
                    self.tagColor = .red
                    self.resetForRed()
                }, label: {
                    Text("Red").font(.body).fontWeight(self.redButton ? .bold : .none)
                }).padding(10)
                    .background(TagColor.getBackColor("red"))
                    .foregroundColor(TagColor.getFrontColor("red"))
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color(red: 255/255, green: 0, blue: 31/255, opacity: 0.78), lineWidth: self.redButton ? 3 : 0))
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
