"""曲名・人名を突き合わせるときの畳み方。標準ライブラリだけで書く。

ツールごとに規則が少しずつ違う (空白の範囲・大小文字・全角/半角)。揃えると当たる件数が
変わるので揃えてはいない。名前を付けてここに並べ、どのツールがどれを使うかを見えるように
して、同じ規則の写しを作らない。新しく要るときは、まずここにあるものを使う。
"""

import re
import unicodedata


def squash_spaces(text: str) -> str:
    """空白 (全角空白・改行・タブも含む) を潰す。「所 恵美」と「所恵美」を同じにする。"""
    return re.sub(r"\s+", "", text)


def squash_spaces_lower(text: str) -> str:
    """空白を潰し、大小文字も畳む。`765PRO ALLSTARS` と `765ProAllstars` を同じにする。"""
    return re.sub(r"\s+", "", text).lower()


def drop_spaces_lower(text: str) -> str:
    """半角と全角の空白だけを落とし、大小文字を畳む (改行やタブは残す)。None は空文字。"""
    return (text or "").replace(" ", "").replace("　", "").lower()


def nfkc_drop_spaces(text: str) -> str:
    """NFKC で全角/半角を均し、半角と全角の空白を落とす (大小文字は区別する)。"""
    return unicodedata.normalize("NFKC", text).replace(" ", "").replace("　", "")
