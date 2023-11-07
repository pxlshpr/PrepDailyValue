import SwiftUI
import PrepShared
import PrepSettings

/// [ ] UIse RDI from backend instead of micro.rdis
/// [ ] Assign new biometrics to Biometrics struct
/// [ ] In valueRow, show Bound Text if fixed bound (use what we have in plan)
///     [ ] If based on energy, show the % of energy or x amount per y energy unit amount
///     [ ] If biometrics required, say "requires biometrics"
/// [ ]  If there are any requirements, check biometrics for its availability, otherwise showing a button which presents a sheet with the required biometrics inserted in it

struct RDIPicker: View {
    
    let micro: Micro
    @State var model = Model()
    
    @Environment(BiometricsStore.self) var biometricsStore: BiometricsStore
    
    @Observable class Model {
        var presentedURLString: String? = nil
        var showingWebView: Bool = false
    }
    
    var body: some View {
        Form {
            ForEach(micro.rdis, id: \.self) {
                RDISection(rdi: $0)
                    .environment(model)
                    .environment(biometricsStore)
            }
        }
        .navigationTitle(micro.name)
        .sheet(isPresented: $model.showingWebView) { urlView }
    }
    
    @ViewBuilder
    var urlView: some View {
        if let urlString = model.presentedURLString {
            NavigationStack {
                WebView(urlString: urlString, title: "Source")
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button {
                                model.showingWebView = false
                                model.presentedURLString = nil
                            } label: {
                                Text("Done")
                                    .fontWeight(.bold)
                            }
                        }
                    }
            }
        }
    }
}

struct RDISection: View {
    
    @Environment(RDIPicker.Model.self) var model: RDIPicker.Model
    @Environment(BiometricsStore.self) var biometricsStore: BiometricsStore

    let rdi: RDI
    
    @State var isSmoker: PickableBool = .notSpecified
    @State var isPregnant: PickableBool = .notSpecified
    @State var isLactating: PickableBool = .notSpecified
    @State var sex: BiometricSex = .notSpecified

    var body: some View {
        Section(footer: selectButton) {
            sourceRow
            biometricsRow
            valueRow
        }
        .environment(\.openURL, OpenURLAction(handler: handleURL))
    }
        
    @ViewBuilder
    var sourceRow: some View {
        if let source = rdi.source, let string = rdi.url {
            HStack(alignment: .firstTextBaseline) {
                Text("Source")
                Spacer()
                Text(source.name)
                    .multilineTextAlignment(.trailing)
                    .foregroundStyle(.secondary)
                Link(destination: URL(string: string)!) {
//                        Text(source.name)
                    Image(systemName: "arrow.up.right")
                }
            }
        }
    }
    
    func tag(_ string: String) -> some View {
        Text(string)
            .font(.footnote)
            .foregroundStyle(.secondary)
            .padding(.vertical, 5)
            .padding(.horizontal, 5)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color(.systemGray5))
            )
    }
    
    var valueRow: some View {
        HStack(alignment: .firstTextBaseline) {
            Text("Daily Value")
            Spacer()
            VStack(alignment: .trailing) {

                //TODO: Get params from biometrics
                if let bound = rdi.displayBound(params: RDIParams()) {
                    bound.text(
//                        formatter: <#T##(Double) -> (String)#>, 
                        allowZeroLowerBound: true,
                        unitString: rdi.unit.abbreviation
                    )
                } else {
                    Text("Requires biometrics")
                        .foregroundStyle(.tertiary)
                }
                
                switch rdi.type {
                case .quantityPerEnergy(let double, let energyUnit):
                    tag("per \(double.cleanAmount) \(energyUnit.abbreviation) of energy intake")
                case .percentageOfEnergy:
                    tag("of total energy intake")
                default:
                    EmptyView()
                }
            }
//            if let bound = rdi.bound() {
//                bound.text()
//            } else if rdi.type.usesEnergy {
//                VStack(alignment: .trailing) {
//                    //TODO: Show bound text for actual bound here (not calculated)
//                    HStack {
//                        Text("Minimum")
//                        HStack(spacing: 2) {
//                            Text("14")
//                                .font(.system(.body, design: .monospaced, weight: .semibold))
//                            Text("g")
//                        }
//                    }
//                    .foregroundStyle(.secondary)
//                }
//            } else {
//            }
        }
    }
    
    var selectRow: some View {
        Button {
            
        } label: {
            HStack {
                Spacer()
                Text("Use")
                Spacer()
            }
        }
//            .disabled(true)
    }

    var isSmokerRow: some View {
        HStack {
            Text("Smoker")
            Spacer()
            MenuPicker($isSmoker)
        }
    }

    var isPregnantRow: some View {
        HStack {
            Text("Pregnant")
            Spacer()
            MenuPicker($isPregnant)
        }
    }

    var isLactatingRow: some View {
        HStack {
            Text("Lactating")
            Spacer()
            MenuPicker($isLactating)
        }
    }

    var sexRow: some View {
        HStack {
            Text("Biological Sex")
            Spacer()
            MenuPicker($sex)
        }
    }
    
    var ageRow: some View {
        HStack {
            NavigationLink {
                
            } label: {
                HStack {
                    Text("Age")
                    Spacer()
                    Text("Not specified")
                        .foregroundStyle(.tertiary)
                        .multilineTextAlignment(.trailing)
                }
            }
        }
    }
    
    @ViewBuilder
    var biometricsRow: some View {
        if rdi.requiresBiometrics {
            HStack {
                NavigationLink {
                    BiometricsForm(biometricsStore, [.age, .sex])
                } label: {
                    HStack {
                        Text("Health Data")
                        Spacer()
                        Text("Incomplete")
                            .foregroundStyle(.tertiary)
                            .multilineTextAlignment(.trailing)
                    }
                }
            }
        }
    }
    
    var selectButton: some View {
        var selected: Bool {
            rdi.source?.name == "Mayo Clinic"
        }
        
        var selectedView: some View {
//            Button {
//                
//            } label: {
                Text("Selected")
                    .textCase(.none)
                    .foregroundStyle(.secondary)
                    .font(.headline)
//            }
//            .buttonStyle(.borderless)
//            .disabled(true)
        }
        
        var button: some View {
            Button {
                
            } label: {
                Text("Select")
                    .textCase(.none)
            }
            .buttonStyle(.borderedProminent)
        }
        
        return HStack {
            Spacer()
            if selected {
                selectedView
            } else {
                button
            }
        }
    }
    
    func handleURL(_ url: URL) -> OpenURLAction.Result {
        model.presentedURLString = url.absoluteString
        model.showingWebView = true
        return .handled
    }
}

public extension RDI {
    
    /// Bound used when dispalying this RDI as an option
    func displayBound(params: RDIParams) -> Bound? {
        /// If there's only one value, return that
        if values.count == 1 {
            return values.first?.bound
        }
        
        return self.bound(params: params)
    }
    
    var requiresBiometrics: Bool {
        values.count > 1
    }
}

let dummyBiometricsStore = BiometricsStore(currentBiometricsHandler: {
        Biometrics()
}, saveHandler: { biometrics, isCurrent in
    
})

#Preview {
    NavigationStack {
        RDIPicker(micro: .transFat, model: .init())
            .environment(dummyBiometricsStore)
    }
}
#Preview {
    NavigationStack {
        RDIPicker(micro: .dietaryFiber, model: .init())
            .environment(dummyBiometricsStore)
    }
}
