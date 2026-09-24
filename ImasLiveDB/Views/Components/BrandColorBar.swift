import SwiftUI

/// イベントカード左端のブランドカラーバー
struct BrandColorBar: View {
    let brandId: String?

    var body: some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(brandColor)
            .frame(width: 4, height: 40)
    }

    private var brandColor: Color {
        guard let hex = BrandColors.hex(for: brandId) else { return .gray }
        return Color(hexString: hex)
    }
}

/// ブランド色ドット + 略称 + 件数 のセクション見出し。
/// アイドル一覧/グリッドのブランド区切り見出しを 1 部品に統一。
/// 末尾の開閉シェブロン等は呼び出し側で HStack に並べる (本部品は Spacer まで)。
struct BrandSectionHeader: View {
    let brand: Brand
    /// 件数の表示 (「12人」「5組」など)。
    let countLabel: DisplayText

    /// 件数を文言で渡す (例: `.key(L10n.Units.listBrandCount(count: n))`)。人数以外の単位はこちら。
    init(brand: Brand, countLabel: DisplayText) {
        self.brand = brand
        self.countLabel = countLabel
    }

    /// 人数の見出し (「12人」)。
    ///
    /// `unit` は単位を String で渡していたころの入口 (移行中だけ残す)。渡すと従来どおり
    /// 件数 (桁区切り) に単位を続けてそのまま出す。新しい呼び出しは `countLabel:` を使う。
    init(brand: Brand, count: Int, unit: String? = nil) {
        self.brand = brand
        if let unit {
            self.countLabel = .verbatim("\(count.formatted())\(unit)")
        } else {
            self.countLabel = .key(L10n.Common.brandSectionCountPeople(count: count))
        }
    }

    var body: some View {
        HStack(spacing: DS.sp3) {
            Circle()
                .fill(Color(hexString: brand.color, default: DS.ink3))
                .frame(width: 9, height: 9)
            Text(brand.shortName)
                .font(.imasScaled( 13, weight: .semibold))
                .foregroundStyle(DS.ink2)
            Text(display: countLabel)
                .font(.imasCaption)
                .foregroundStyle(DS.ink3)
            Spacer()
        }
    }
}
