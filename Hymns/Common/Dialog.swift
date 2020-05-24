import SwiftUI

/**
 * Shows a dialog and dims the background
 */
struct Dialog<Content: View>: View {

    @Binding private var contentBuilder: (() -> Content)?

    init(contentBuilder: Binding<(() -> Content)?>) {
        self._contentBuilder = contentBuilder
    }

    var body: some View {
        ZStack {
            Color.black.opacity(0.66).edgesIgnoringSafeArea(.all).onTapGesture {
                    self.contentBuilder = nil
            }
            self.contentBuilder.map { content in
                content().background(Color(UIColor.systemBackground))
            }
        }.edgesIgnoringSafeArea(.all)
    }
}

#if DEBUG
struct Dialog_Previews: PreviewProvider {

    static var previews: some View {
        let backgroundText = Text("""
I'm baby kale chips bushwick whatever irony umami paleo. Selvage selfies art party vinyl distillery fanny pack. Taxidermy farm-to-table snackwave, narwhal copper mug listicle hashtag chambray tofu ethical forage pug chillwave kitsch sriracha. Slow-carb pabst poke listicle coloring book locavore williamsburg.

Fam asymmetrical whatever VHS pop-up leggings gastropub af iPhone sartorial chartreuse palo santo man braid. Chartreuse fanny pack organic, vexillologist lomo asymmetrical af. Wolf chia swag live-edge butcher VHS la croix, scenester deep v tote bag lomo. Ugh jianbing pitchfork vegan farm-to-table normcore synth green juice beard distillery hot chicken.

Palo santo seitan actually aesthetic. Narwhal plaid chambray schlitz pour-over kickstarter master cleanse letterpress glossier franzen. 3 wolf moon kinfolk leggings taxidermy. Farm-to-table artisan poke kale chips. Hoodie vinyl jean shorts taiyaki aesthetic artisan, meh church-key cold-pressed seitan blue bottle celiac irony.

Aesthetic flexitarian deep v, activated charcoal echo park vaporware fingerstache authentic vegan art party la croix distillery. Lomo bushwick sartorial polaroid tousled cred hoodie fam biodiesel leggings bitters hot chicken bicycle rights. Intelligentsia meh bespoke food truck, ramps tattooed lo-fi. Etsy leggings actually try-hard blue bottle taiyaki tattooed trust fund synth brooklyn you probably haven't heard of them biodiesel. Ethical lumbersexual lomo poke truffaut banh mi. Shaman raw denim chartreuse ennui semiotics meditation shabby chic. Salvia banh mi art party, asymmetrical gochujang la croix cloud bread slow-carb trust fund quinoa 3 wolf moon literally whatever.

Pickled cred skateboard photo booth cornhole kombucha lumbersexual pop-up jianbing slow-carb leggings fanny pack. Snackwave +1 cold-pressed post-ironic pop-up franzen distillery typewriter. Neutra tofu thundercats, artisan yuccie cardigan PBR&B messenger bag selvage. Chicharrones tousled tumeric heirloom mlkshk humblebrag butcher distillery post-ironic XOXO deep v normcore.

Dummy text? More like dummy thicc text, amirite?
""")

        var contentBuilder: (() -> AnyView)? = {
            Text("Example Text").eraseToAnyView()
        }
        let dialog = Dialog(
            contentBuilder: Binding<(() -> AnyView)?>(
                get: {contentBuilder},
                set: {contentBuilder = $0}))
        return Group {
            ZStack {
                backgroundText
                dialog
            }.toPreviews()
        }
    }
}
#endif
