import asyncio

from flask import Flask, make_response, url_for, redirect, send_from_directory
# app = Flask(__name__, static_url_path="", static_folder="/_build/html/_static")
app = Flask(__name__)

@app.route("/")
def index():
    return send_from_directory("_build/html", "index.html")

@app.route('/<path:file>')
def serve_docs(file):
    return send_from_directory('_build/html/', file)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
