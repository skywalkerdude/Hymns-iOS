import SwiftUI

struct DetailedHymnToolbarView: View {
    
    var body: some View {
        VStack {
            Divider().shadow(radius: 2)
            HStack(spacing: 50) {

                Button(action: {print("action here")}) {                    DetailToolbar.info.getImage()
                }
                Button(action: {print("action here")}) {                    DetailToolbar.share.getImage()
                }
                Button(action: {print("action here")}) {                    DetailToolbar.textSize.getImage()
                }
                Button(action: {print("action here")}) {                    DetailToolbar.tags.getImage()
                }
                Button(action: {print("action here")}) {                    DetailToolbar.tune.getImage()
                }
                Button(action: {print("action here")}) {                    DetailToolbar.musicPlayer.getImage()
                    
                }
 }.padding(10).accentColor(Color.black).edgesIgnoringSafeArea(.horizontal)
        }
    }
}

struct DetailedHymnToolbarView_Previews: PreviewProvider {
    static var previews: some View {
        DetailedHymnToolbarView()
    }
}
