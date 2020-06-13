import SwiftUI

struct ColorSelectorView: View {

    @Binding var tagColor: TagColor

    var body: some View {
        VStack(alignment: .leading) {
            Text("Select a color").font(.body).fontWeight(.bold)
            HStack {
                ForEach(TagColor.allColors, id: \.self) { tagColor in
                    Button(action: {
                        if self.tagColor == tagColor {
                            self.tagColor = .none
                        } else {
                            self.tagColor = tagColor
                        }
                    }, label: {
                        Text(tagColor.name)
                            .font(.body)
                            .fontWeight(self.tagColor == tagColor ? .bold : .none)
                    }).padding(10)
                        .background(tagColor.background)
                        .foregroundColor(tagColor.foreground)
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(tagColor.foreground, lineWidth: self.tagColor == tagColor ? 3 : 0)
                    )
                }
            }.padding(.top)
        }
    }
}

struct SelectLabelView_Previews: PreviewProvider {
    static var previews: some View {
        ColorSelectorView(tagColor: .constant(.blue))
    }
}
