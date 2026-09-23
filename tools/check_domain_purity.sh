#!/usr/bin/env bash
# Domain 層と Shared の純粋性チェック (Hexagonal の依存方向ガード)。
#
# 1. Domain (Ports / UseCases / Entities) は SwiftUI / GRDB / CloudKit を import しない。
#    import すると Presentation/Adapters への依存が逆流し「なんちゃってレイヤー」になる。
#    `@preconcurrency import SwiftUI`・`@_exported import SwiftUI`・`import struct SwiftUI.Text`・
#    `@_implementationOnly import GRDB` の形も拾う。
# 2. Domain は文言を文字列に解決しない。LocalizedStringKey / String(localized: / NSLocalizedString を
#    使わず、LocalizedStringResource・DisplayText・生成アクセサ (L10n.*) を値のまま返す
#    (解決するのは View と OS の出口だけ)。
# 3. ImasLiveDB/Shared/ (アプリとウィジェット拡張の両方がコンパイルする) は Foundation と os だけを
#    import する (WidgetShared.swift の「Foundation 以外に依存しないこと」をガードにしたもの)。
#
# 詳細は docs/ARCHITECTURE.md「レイヤ違反の検査」。
#
# 使い方: bash tools/check_domain_purity.sh [ROOT]   (ROOT の既定はカレントディレクトリ = リポジトリルート)
# CI (.github/workflows/architecture-guard.yml) で走る。違反があれば exit 1。
# 検査の正規表現は tools/test_check_domain_purity.py が落ちる例・通る例で固定している。
set -euo pipefail

ROOT="${1:-.}"
DOMAIN_DIR="$ROOT/ImasLiveDB/Domain"
SHARED_DIR="$ROOT/ImasLiveDB/Shared"

# 属性 (@preconcurrency / @_exported / @_implementationOnly / @_spi(X) …) と import の種類
# (struct / class / enum / protocol / typealias / func / var / let) を前に置けるようにする
IMPORT_HEAD='^[[:space:]]*(@[A-Za-z_]+(\([^)]*\))?[[:space:]]+)*import[[:space:]]+((struct|class|enum|protocol|typealias|func|var|let)[[:space:]]+)?'
FORBIDDEN_IMPORT="${IMPORT_HEAD}(SwiftUI|GRDB|CloudKit)([.[:space:]]|$)"
# 行コメント (//) より前に出てくるものだけを数える (ドキュメントコメントの説明文は違反にしない)
FORBIDDEN_L10N='^([^/]|/[^/])*(LocalizedStringKey|String\(localized:|NSLocalizedString)'
SHARED_ALLOWED="${IMPORT_HEAD}(Foundation|os)([.[:space:]]|$)"

if [[ ! -d "$DOMAIN_DIR" ]]; then
    echo "error: $DOMAIN_DIR が見つかりません (リポジトリルートで実行するか、ルートを引数に渡してください)" >&2
    exit 2
fi

failed=0

violations=$(grep -rnE --include='*.swift' "$FORBIDDEN_IMPORT" "$DOMAIN_DIR" || true)
if [[ -n "$violations" ]]; then
    echo "❌ Domain 純粋性違反: 以下のファイルが SwiftUI/GRDB/CloudKit を import しています" >&2
    echo "$violations" >&2
    echo "→ 永続化/UI 依存は Adapters 側へ。Domain は Foundation のみに保つこと。" >&2
    failed=1
fi

violations=$(grep -rnE --include='*.swift' "$FORBIDDEN_L10N" "$DOMAIN_DIR" || true)
if [[ -n "$violations" ]]; then
    echo "❌ Domain 純粋性違反: 以下のファイルが文言を文字列に解決しています (LocalizedStringKey / String(localized: / NSLocalizedString)" >&2
    echo "$violations" >&2
    echo "→ Domain は LocalizedStringResource・DisplayText・L10n.* を値のまま返す。解決は View と OS の出口で。" >&2
    failed=1
fi

if [[ -d "$SHARED_DIR" ]]; then
    violations=$(grep -rnE --include='*.swift' "${IMPORT_HEAD}[A-Za-z_]" "$SHARED_DIR" | grep -vE "^[^:]+:[0-9]+:${SHARED_ALLOWED#^}" || true)
    if [[ -n "$violations" ]]; then
        echo "❌ Shared 純粋性違反: ImasLiveDB/Shared は Foundation と os だけを import します" >&2
        echo "$violations" >&2
        echo "→ Shared はアプリとウィジェット拡張の両方がコンパイルする。UI やフレームワーク依存は各ターゲット側へ。" >&2
        failed=1
    fi
fi

if [[ "$failed" -ne 0 ]]; then
    exit 1
fi

echo "✅ Domain 純粋: $DOMAIN_DIR に SwiftUI/GRDB/CloudKit の import と文言の解決なし"
if [[ -d "$SHARED_DIR" ]]; then
    echo "✅ Shared 純粋: $SHARED_DIR は Foundation / os だけを import"
fi
