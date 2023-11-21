import flask
import json



with open("config.json", "r") as configFile:
    config = json.load(configFile)
    
name: str = config["settings"]["serverName"]
port: str = config["settings"]["serverPort"]

app = flask.Flask(__name__)

@app.route("/")
def default():
    return name

app.run("0.0.0.0", port)