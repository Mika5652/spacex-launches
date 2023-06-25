import SharedModels
import SwiftUI

public struct LaunchDetailView: View {
    private let item: PastLaunch

    public init(item: PastLaunch) {
        self.item = item
    }

    public var body: some View {
        Form {
            Section("Date of launch") {
                LabeledContent("Date", value: item.dateUtc, format: .dateTime.day().month().year())
                LabeledContent("Time", value: item.dateUtc, format: .dateTime.hour().minute())
                if let status = item.launchSuccessStatus {
                    LabeledContent("Status", value: status)
                }
            }
            if let details = item.details {
                Section("Description") {
                    Text(details)
                }
            }
            if let links = item.links {
                Section("References") {
                    if let presskit = links.presskit {
                        Link("Presskit", destination: presskit)
                    }
                    if let webcast = links.webcast {
                        Link("Webcast", destination: webcast)
                    }
                    if let article = links.article {
                        Link("Article", destination: article)
                    }
                    if let wikipedia = links.wikipedia {
                        Link("Wikipedia", destination: wikipedia)
                    }
                }
            }
        }
        .navigationTitle(item.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct LaunchDetailView_Preview: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LaunchDetailView(item: .mock())
        }
    }
}
