import SwiftUI

struct SelectLabelView: View {
    var body: some View {
        VStack {
            HStack {
                Text("Select a color").font(.body).fontWeight(.bold)
                Spacer()
            }
            HStack {

                Button(action: {}, label: {
                    Text("blue")
                }).padding(6)
                    .background(Color(UIColor(red: 2/255, green: 118/255, blue: 254/255, alpha: 0.2)))                                            .foregroundColor(.blue)
                    .cornerRadius(13)

                Button(action: {}, label: {
                    Text("green")
                }).padding(6)
                    .background(Color(UIColor(red: 80/255, green: 227/255, blue: 194/255, alpha: 0.2)))
                    .foregroundColor(Color(UIColor(red: 35/255, green: 190/255, blue: 155/255, alpha: 1.0)))
                    .cornerRadius(13)

                Button(action: {}, label: {
                    Text("yellow")
                }).padding(6)
                    .background(Color(UIColor(red: 255/255, green: 209/255, blue: 0/255, alpha: 0.2)))
                    .foregroundColor(Color(UIColor(red: 176/255, green: 146/255, blue: 7/255, alpha: 1.0)))
                    .cornerRadius(13)

                Button(action: {}, label: {
                    Text("red")
                }).padding(6)
                    .background(Color(UIColor(red: 255/255, green: 0, blue: 31/255, alpha: 0.2)))
                    .foregroundColor(Color(UIColor(red: 255/255, green: 0, blue: 31/255, alpha: 0.78)))
                    .cornerRadius(13)
                Spacer()
            }.padding(.top)
        }
    }
}

struct SelectLabelView_Previews: PreviewProvider {
    static var previews: some View {
        SelectLabelView()
    }
}
