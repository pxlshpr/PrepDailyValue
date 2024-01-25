import SwiftUI
import PrepShared
import PrepSettings

public struct MicrosSettings: View {
    
    @Environment(Provider.self) var provider: Provider

    public init() {
        
    }
    
    public var body: some View {
        NavigationStack {
            Form {
                ForEach(MicroGroup.allCases, id: \.self) {
                    sections(for: $0)
                }
            }
            .navigationTitle("Micronutrients")
        }
    }
    
    func sections(for group: MicroGroup) -> some View {
        ForEach(Array(zip(group.micros.indices, group.micros)), id: \.0) { (index, group) in
            section(for: group, at: index)
        }
    }
    
    func section(for micro: Micro, at index: Int) -> some View {
        @ViewBuilder
        var header: some View {
            if index == 0 {
                Text(micro.group?.name ?? "")
                    .formTitleStyle()
                    .padding(.top, 10)
            }
        }
        
        var navigationLink: some View {
            var label: some View {
                var topRow: some View {
                    HStack {
                        Text(micro.name)
                            .font(.system(.footnote, weight: .semibold))
                            .foregroundStyle(Color(.secondaryLabel))
                        Spacer()
                    }
                }
                
                var bottomRow: some View {
                    HStack {
                        Spacer()
                        ZStack {
                            
                            /// Dummy text placed to ensure height is consistent among cells despite the smaller font for empty value
                            Text(" ")
                                .font(.system(.title2, design: .rounded, weight: .medium))
                                .opacity(0)

                            if micro == .monounsaturatedFat {
                                HStack(alignment: .firstTextBaseline, spacing: 2) {
                                    Text("15 - 2000")
                                        .font(.system(.title2, design: .rounded, weight: .medium))
                                        .foregroundStyle(Color(.label))
                                    Text("mg/kcal")
                                        .font(Font.system(.callout, design: .rounded, weight: .medium))
                                        .foregroundStyle(Color(.secondaryLabel))
                                }
                            } else {
                                Text("Not Set")
                                    .foregroundStyle(Color(.tertiaryLabel))
                            }
                        }
                    }
                }
                
                return VStack {
                    topRow
                        .padding(.bottom, 10)
                    bottomRow
                }
            }
            
            return NavigationLink {
                MicroSettings(micro, provider)
            } label: {
                label
            }
        }
        
        return Section(header: header) {
            navigationLink
        }
        .listSectionSpacing(.compact)
    }
}

#Preview {
    MicrosSettings()
        .environment(Provider.shared)
}
