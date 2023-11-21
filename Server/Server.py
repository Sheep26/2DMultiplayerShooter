from flask import Flask
from flask import request
from flask import Response
import json
from player import Player

players = []

with open("config.json", "r") as configFile:
    config = json.load(configFile)
    
name: str = config["settings"]["serverName"]
port: str = config["settings"]["serverPort"]

app = Flask(__name__)

@app.route("/")
def default():
    return name

@app.route("/getPlayerFromID")
def getPlayerFromID():
    id = request.args["id"]
    for player in players:
        if player.id == id:
            return player
    return ""

app.run("0.0.0.0", port)