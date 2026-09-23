"""iTunes Search API の送り方と応答の読み方。標準ライブラリだけで書く。

ツールごとに違うもの (User-Agent・待ち時間・件数・失敗したときに止めるか空で続けるか)
は呼ぶ側が決める。ここは URL の組み立て・送信・results の取り出しと、artwork の
大きさの規則を 1 つにする。テストは urlopen を記録した形の応答に差し替える。
"""

import json
import urllib.parse
import urllib.request

BASE = "https://itunes.apple.com"

# 送信の口。テストは偽物に差し替える。
urlopen = urllib.request.urlopen


def get_json(url: str, *, user_agent: str, timeout: float) -> dict:
    req = urllib.request.Request(url, headers={"User-Agent": user_agent})
    with urlopen(req, timeout=timeout) as res:
        return json.load(res)


def results(path: str, params: dict, *, user_agent: str, timeout: float) -> list:
    """`https://itunes.apple.com/<path>?<params>` の results (params の順に並べる)。"""
    url = f"{BASE}/{path}?{urllib.parse.urlencode(params)}"
    return get_json(url, user_agent=user_agent, timeout=timeout).get("results", [])


def song_search(term: str, limit: int = 200) -> dict:
    """日本のストアで曲を探す引数。"""
    return {"term": term, "entity": "song", "country": "jp", "limit": limit}


def artwork_600(result: dict, fallback_60: bool = False) -> str:
    """一覧で使える大きさ (600x600) の artwork の URL。既定の 100x100 は粗い。

    fallback_60 のときは、artworkUrl100 が無ければ artworkUrl60 を使う
    (こちらは大きさを差し替えない)。
    """
    url = result.get("artworkUrl100") or (fallback_60 and result.get("artworkUrl60")) or ""
    return url.replace("100x100bb", "600x600bb")
