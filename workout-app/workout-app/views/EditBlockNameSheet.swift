import SwiftUI
import SwiftData

struct EditBlockNameSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var block: Block
    @Binding var editedName: String

    var body: some View {
        NavigationStack {
            Form {
                Section("Block Name") {
                    TextField("Block name", text: $editedName)
                }
            }
            .navigationTitle("Edit Block")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        block.name = editedName
                        dismiss()
                    }
                    .disabled(editedName.isEmpty)
                }
            }
        }
        .presentationDetents([.height(200)])
    }
}
