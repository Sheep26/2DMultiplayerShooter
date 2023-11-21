from flask import Flask
from flask import request
from flask import Response
import json
from player import Player
from random import randint

players = []
map: str

with open("config.json", "r") as configFile:
    config = json.load(configFile)
    
name: str = config["settings"]["serverName"]
port: str = config["settings"]["serverPort"]

app = Flask(__name__)

@app.route("/")
def default():
    Response(name, 200)

@app.route("/join")
def join():
    playerName = request.args["name"]
    id = ""
    for n in range(9):
        id += str(randint(0, 9))
    player = Player(playerName, id)
    players.append(player)
    return Response(f"", 200)

@app.route("/getPlayerFromID")
def getPlayerFromID():
    id = request.args["id"]
    for player in players:
        if player.id == id:
            Response(player, 200)
    return Response(status=404)

app.run("0.0.0.0", port)