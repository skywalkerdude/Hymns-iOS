import Resolver
import SwiftUI

struct DisplayHymnPdfView: View {

    let url: URL
    let pdfPreloader: PDFLoader

    init(url: URL, pdfPreloader: PDFLoader = Resolver.resolve()) {
        self.url = url
        self.pdfPreloader = pdfPreloader
    }

    @State private var showPdfSheet = false

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Button(action: {
                self.showPdfSheet = true
            }, label: {
                Image(systemName: "square.and.arrow.up").accessibility(label: Text("Maximize music")).padding()
            }).zIndex(1)
            PDFViewer(preloader: pdfPreloader, url: url)
        }.sheet(isPresented: $showPdfSheet) {
            ZStack(alignment: .topLeading) {
                Button(action: {
                    self.showPdfSheet = false
                }, label: {
                    Text("Close").padding()
                }).zIndex(1)
                PDFViewer(url: self.url)
            }
        }
    }
}

struct DisplayHymnPdfView_Previews: PreviewProvider {
    static var previews: some View {
        DisplayHymnPdfView(url: URL(string: "http://www.hymnal.net/en/hymn/h/40/f=gtpdf")!).previewLayout(.sizeThatFits)
    }
}
