from flask import Flask
from flask import request
from flask import Response
import json
from player import Player
from random import randint
from maps import Map
from maps import Maps

players = []
map: Map
map = Maps[0]

with open("config.json", "r") as configFile:
    config = json.load(configFile)
    
name: str = config["settings"]["serverName"]
port: str = config["settings"]["serverPort"]

app = Flask(__name__)

@app.route("/")
def default():
    Response(name, 200)

@app.route("/setMap")
def setMap():
    mapName = request.args["map"]
    for map1 in Maps:
        if map1.name == mapName:
            map = map1
            
def getMap():
    return Response(f"{map.path}")

@app.route("/join")
def join():
    playerName = request.args["name"]
    id = ""
    for n in range(9):
        id += str(randint(0, 9))
    player = Player(playerName, id, map)
    players.append(player)
    return Response(f"{player.name}:{player.id}:{map.name}:{map.path}:{player.x}:{player.y}", status=200)

@app.route("/getPlayers")
def getPlayers():
    returnList = []
    for player in players:
        returnList.append(f"{player.name}:{player.id}:{player.x}:{player.y}:{player.currentGunID}")
    return Response(str(returnList).replace('\'', "").replace("[", "").replace("]", "").replace(",", "\n"))

@app.route("/getPlayerFromID")
def getPlayerFromID():
    id = request.args["id"]
    for player in players:
        if player.id == id:
            Response(f"{player.name}:{player.id}:{player.x}:{player.y}:{player.currentGunID}", status=200)
    return Response(status=404)

app.run("0.0.0.0", port)