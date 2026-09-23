"""CLDR の複数形の範疇と、count 引数の桁区切り (整数だけ)。

生成器が知っている言語はここに並ぶものだけ。言語を足すときは、範疇・整数の規則・
桁区切りの 3 つをここに足す (i18n/config.json に書く前に)。

- 範疇はカタログの複数形オブジェクトのキー (`{"one": …, "other": …}`) に使える名前。
- 規則は count の見本 (1, 3, 1234) の期待値を計算するのに使う。整数しか来ないので
  小数の条件 (v, f, t) は持たない。
- 桁区切りは「引数の型と数の書式」(i18n/README.md)の「count はロケールの桁区切り」の期待値用。iOS の `%lld` と
  Android の `%,d` がこの記号になることを両プラットフォームのテストで確かめる。
  (es のように 4 桁で区切らない言語は iOS と Java で結果が割れるので、足すときに実測する)
"""


def _other(n):
    return "other"


def _one_other(n):
    return "one" if n == 1 else "other"


# 言語コード → (範疇, 整数 n の範疇を返す関数, 桁区切り)
_TABLE = {
    "ja": (("other",), _other, ","),
    "ko": (("other",), _other, ","),
    "zh-Hans": (("other",), _other, ","),
    "zh-Hant": (("other",), _other, ","),
    "en": (("one", "other"), _one_other, ","),
}

LANGUAGES = tuple(sorted(_TABLE))


def known(lang):
    return lang in _TABLE


def categories(lang):
    """lang の複数形の範疇 (CLDR の並び: zero one two few many other)。"""
    return _TABLE[lang][0]


def category_for(lang, n):
    """整数 n が lang でどの範疇になるか。"""
    return _TABLE[lang][1](n)


def group(lang, n):
    """count の期待値: n を lang の桁区切りで書く (3 桁ごと)。"""
    sep = _TABLE[lang][2]
    sign = "-" if n < 0 else ""
    digits = str(abs(n))
    parts = []
    while len(digits) > 3:
        parts.insert(0, digits[-3:])
        digits = digits[:-3]
    parts.insert(0, digits)
    return sign + sep.join(parts)
