import SwiftUI
import MapboxMaps

struct LocateButton: View {
    @Binding var viewport: Viewport

    var body: some View {
        Button {
            withViewportAnimation(.default(maxDuration: 1)) {
                if isFocusingUser {
                    viewport = .followPuck(zoom: 18, bearing: .heading, pitch: 60)
                } else if isFollowingUser {
                    viewport = .idle
                } else {
                    viewport = .followPuck(zoom: 16, bearing: .constant(0))
                }
            }
        } label: {
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .transition(.scale.animation(.easeOut))
                .frame(width: 30, height: 30)
                .padding(20)
        }

    }

    private var isFocusingUser: Bool {
        return viewport.followPuck?.bearing == .constant(0)
    }

    private var isFollowingUser: Bool {
        return viewport.followPuck?.bearing == .heading
    }

    private var imageName: String {
        if isFocusingUser {
           return  "location.fill"
        } else if isFollowingUser {
           return "location.north.line.fill"
        }
        return "location"
    }
}

