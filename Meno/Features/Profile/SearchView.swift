import SwiftUI

/// Screens 53 & 54 — Global Search.
/// Empty state shows what women are searching; a query reveals grouped results.
struct SearchView: View {
    @EnvironmentObject var store: MenoStore
    @Environment(\.dismiss) private var dismiss
    @State private var query = ""
    @FocusState private var focused: Bool
    @State private var filter = "All"

    private let filters = ["All", "Posts", "Wisdom", "Products"]
    private var hasQuery: Bool { !query.trimmingCharacters(in: .whitespaces).isEmpty }

    var body: some View {
        VStack(spacing: 0) {
            // Search field
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 17)).foregroundStyle(Meno.muted)
                TextField("Search Meno", text: $query)
                    .font(.sans(16)).foregroundStyle(Meno.ink)
                    .focused($focused)
                    .submitLabel(.search)
            }
            .padding(.horizontal, 16)
            .frame(height: 50)
            .background(
                RoundedRectangle(cornerRadius: Meno.rField, style: .continuous)
                    .fill(Meno.surface)
                    .overlay(RoundedRectangle(cornerRadius: Meno.rField, style: .continuous).stroke(Meno.border, lineWidth: 1.5))
            )
            .padding(.horizontal, 20)
            .padding(.top, 2)
            .padding(.bottom, hasQuery ? 10 : 12)

            if hasQuery { resultsView } else { emptyView }
        }
        .background(Meno.base)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left").foregroundStyle(Meno.faint)
                }
            }
        }
        .onAppear { focused = true }
    }

    // 53 — empty
    private var emptyView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                SectionLabel(text: "Women are searching")
                FlowChips(items: store.searchSuggestions) { query = $0 }
            }
            .padding(.horizontal, 22)
            .padding(.top, 4)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    // 54 — results
    private var resultsView: some View {
        VStack(spacing: 0) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(filters, id: \.self) { f in
                        Button { filter = f } label: { Chip(title: f, selected: filter == f, height: 34) }
                            .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 20)
            }
            .padding(.bottom, 10)

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    let wisdom = store.searchResults.filter { $0.group == .wisdom }
                    let products = store.searchResults.filter { $0.group == .product }

                    if filter == "All" || filter == "Wisdom", !wisdom.isEmpty {
                        SectionLabel(text: "Wisdom", color: Meno.sage).padding(.bottom, 10)
                        ForEach(wisdom) { r in wisdomCard(r) }
                    }
                    if filter == "All" || filter == "Products", !products.isEmpty {
                        SectionLabel(text: "Products", color: Meno.clay)
                            .padding(.top, 14).padding(.bottom, 10)
                        ForEach(products) { r in productCard(r) }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }

    private func wisdomCard(_ r: SearchResult) -> some View {
        MenoCard(padding: 14) {
            VStack(alignment: .leading, spacing: 4) {
                Text(r.title).font(.sans(16, .bold)).foregroundStyle(Meno.ink).lineSpacing(2)
                Text(r.meta).font(.sans(13)).foregroundStyle(Meno.muted)
            }
        }
        .padding(.bottom, 14)
    }

    private func productCard(_ r: SearchResult) -> some View {
        MenoCard(padding: 12) {
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(LinearGradient(colors: [Meno.clay.opacity(0.18), Meno.sage.opacity(0.14)],
                                         startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 50, height: 50)
                VStack(alignment: .leading, spacing: 2) {
                    Text(r.title).font(.sans(15, .bold)).foregroundStyle(Meno.ink)
                    Text(r.meta).font(.sans(13)).foregroundStyle(Meno.muted)
                }
                Spacer()
            }
        }
        .padding(.bottom, 14)
    }
}

/// Simple wrapping chip layout for suggestion tags.
struct FlowChips: View {
    let items: [String]
    var onTap: (String) -> Void = { _ in }

    var body: some View {
        FlexibleWrap(items: items, spacing: 10) { item in
            Button { onTap(item) } label: {
                Text(item)
                    .font(.sans(15, .bold)).foregroundStyle(Meno.sub)
                    .padding(.horizontal, 18)
                    .frame(height: 42)
                    .background(Meno.surface)
                    .overlay(Capsule().stroke(Meno.border, lineWidth: 1.5))
                    .clipShape(Capsule())
            }
            .buttonStyle(.plain)
        }
    }
}

/// Lightweight flow layout (wraps chips onto multiple rows).
struct FlexibleWrap<Item: Hashable, Content: View>: View {
    let items: [Item]
    var spacing: CGFloat = 10
    @ViewBuilder var content: (Item) -> Content

    var body: some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        return GeometryReader { geo in
            ZStack(alignment: .topLeading) {
                ForEach(items, id: \.self) { item in
                    content(item)
                        .alignmentGuide(.leading) { d in
                            if abs(width - d.width) > geo.size.width {
                                width = 0; height -= d.height + spacing
                            }
                            let result = width
                            width = (item == items.last) ? 0 : width - d.width - spacing
                            return result
                        }
                        .alignmentGuide(.top) { _ in
                            let result = height
                            if item == items.last { height = 0 }
                            return result
                        }
                }
            }
        }
        .frame(height: 140)
    }
}

#Preview { NavigationStack { SearchView() }.environmentObject(MenoStore()) }
