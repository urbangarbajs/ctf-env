from flask import Flask, jsonify, request

app = Flask(__name__)

API_KEY = "np2-api-key-preview-2026"

ARTICLES = {
    "2001": {
        "id": "2001",
        "title": "Osnutek: prenova jutranjega uredniskega sestanka",
        "author": "ana.zupan",
        "classification": "draft",
        "body": "Urednistvo preizkusa nov razpored priprave naslovnice in rubrik.",
    },
    "2002": {
        "id": "2002",
        "title": "Osnutek: lokalni dopisniki in preverjanje virov",
        "author": "lara.vidmar",
        "classification": "draft",
        "body": "Novi tok predvideva dvojno preverjanje zunanjih virov pred objavo.",
    },
    "9009": {
        "id": "9009",
        "title": "Zaupno: varnostni pregled pilotnega uredniskega API-ja",
        "author": "it.podpora",
        "classification": "confidential",
        "body": "Dostop do tega osnutka ni prikazan v standardnem seznamu. NP2-CTF{BROKEN_ACCESS_CONTROL_DRAFT}",
    },
}


def require_api_key():
    return request.headers.get("X-API-Key") == API_KEY


@app.get("/")
def index():
    return "NovaPress editorial-api\n", 200, {"Content-Type": "text/plain; charset=utf-8"}


@app.get("/internal/status")
def internal_status():
    return jsonify(
        {
            "service": "editorial-api",
            "environment": "staging",
            "flag": "NP2-CTF{SSRF_REACHED_INTERNAL_API}",
        }
    )


@app.get("/api/articles")
def article_list():
    if not require_api_key():
        return jsonify({"error": "missing or invalid API key"}), 401
    visible = [
        {"id": ARTICLES["2001"]["id"], "title": ARTICLES["2001"]["title"]},
        {"id": ARTICLES["2002"]["id"], "title": ARTICLES["2002"]["title"]},
    ]
    return jsonify({"articles": visible})


@app.get("/api/articles/<article_id>")
def article_detail(article_id):
    if not require_api_key():
        return jsonify({"error": "missing or invalid API key"}), 401
    article = ARTICLES.get(article_id)
    if not article:
        return jsonify({"error": "article not found"}), 404
    return jsonify(article)


@app.post("/api/render-preview")
def render_preview():
    if not require_api_key():
        return jsonify({"error": "missing or invalid API key"}), 401
    data = request.get_json(silent=True) or {}
    article_id = str(data.get("article_id", ""))
    article = ARTICLES.get(article_id)
    if not article:
        return jsonify({"error": "article not found"}), 404
    html = f"<article><h1>{article['title']}</h1><p>{article['body']}</p></article>"
    return jsonify({"article_id": article_id, "html": html})


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
