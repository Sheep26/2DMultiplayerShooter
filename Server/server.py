from flask import Flask
from flask import request
from flask import Response
import json
from player import Player
from random import randint
from maps import Map
from maps import Maps
import _thread
from time import time

players = []
map: Map
map = Maps[0]

with open("config.json", "r") as configFile:
    config = json.load(configFile)

name: str = config["settings"]["serverName"]
port: str = config["settings"]["serverPort"]
maxPlayers: int = config["settings"]["maxPlayers"]

app = Flask(__name__)

def getPlayerFromID(id: int) -> Player:
    for player in players:
        if player.id == id:
            return player
    return None

@app.route("/")
def default():
    Response(name, 200)

@app.route("/setMap")
def setMap():
    mapName = request.args["map"]
    for map1 in Maps:
        if map1.name == mapName:
            map = map1

@app.route("/getMap")   
def getMap():
    return Response(f"{map.path}")

@app.route("/join")
def join():
    if len(players) >= maxPlayers:
        return Response("Max Players Reached", 423)
    playerName = request.args["name"]
    id = ""
    for n in range(9):
        id += str(randint(0, 9))
    player = Player(playerName, id, map)
    players.append(player)
    return Response(f"{player.name}:{player.id}:{map.name}:{map.path}:{player.x}:{player.y}", status=200)

@app.route("leave")
def leave():
    id = request.args["id"]
    try:
        player = getPlayerFromID(id)
        players.remove(player)
        return Response(status=200)
    except:
        return Response(status=400)

@app.route("/getPlayers")
def getPlayers():
    returnList = []
    for player in players:
        returnList.append(f"{player.name}:{player.id}:{player.x}:{player.y}:{player.currentGunID}")
    return Response(str(returnList).replace('\'', "").replace("[", "").replace("]", "").replace(",", "\n"))

@app.route("/getPlayerFromID")
def getPlayerFromIDRequest():
    id = request.args["id"]
    for player in players:
        if player.id == id:
            Response(f"{player.name}:{player.id}:{player.x}:{player.y}:{player.currentGunID}", status=200)
    return Response(status=400)

@app.route("/keepAlive")
def keepAlive():
    id = request.args["id"]
    player = getPlayerFromID(id)
    player.setAlive()
    
@app.route("/setPos")
def setPos():
    id = request.args["id"]
    x = request.args["x"]
    y = request.args["y"]
    player = getPlayerFromID(id)
    player.setX(x)
    player.setY(y)
    
def background():
    for player in players:
        if player.getAlive() - time > 2:
            print(f"{player.name} is {player.getAlive() - time}s behind")
        if player.getAlive() - time > 30:
            player.send("kicked?data=timedOut")
            players.remove(player)

_thread.start_new_thread(background)
app.run("0.0.0.0", port)