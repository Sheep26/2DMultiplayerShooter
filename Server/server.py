from flask import Flask
from flask import request
from flask import Response
import json
from player import Player
from random import randint
from maps import Map
from maps import Maps
from maps import level1
import _thread
from time import time
import logging
from bullet import Bullet
from typing import List

players: List[Player] = list()
bullets: List[Bullet] = list()
map: Map = Maps[0]


with open("config.json", "r") as configFile:
    config = json.load(configFile)

name: str = config["generalSettings"]["serverName"]
port: str = config["networkSettings"]["serverPort"]
ip: str = config["networkSettings"]["serverIP"]
maxPlayers: int = int(config["generalSettings"]["maxPlayers"])

app = Flask(__name__)
#log = logging.getLogger('werkzeug')
#log.setLevel(logging.ERROR)

def getPlayerFromID(id: int) -> Player:
    for player in players:
        if player.id == id:
            return player
    return None

@app.route("/")
def default():
    Response(name)

@app.route("/setMap")
def setMap():
    global map
    mapName = request.args["map"]
    for map1 in Maps:
        if map1.name == mapName:
            map = map1

@app.route("/getMap")   
def getMap():
    return Response(f"{map.path}")

@app.route("/join")
def join():
    global players
    if len(players) >= maxPlayers:
        return Response("Max Players Reached", 423)
    playerName = request.args["name"]
    id = ""
    for n in range(9):
        id += str(randint(0, 9))
    player = Player(playerName, id, request.remote_addr, map)
    player.setLastPacketTime()
    players.append(player)
    return Response(f"join:{name}:{map.path}:{map.name}:{player.name}:{player.id}:{player.position.x}:{player.position.y}", status=200)

@app.route("/leave")
def leave():
    id = request.args["id"]
    try:
        player = getPlayerFromID(id)
        players.remove(player)
        return Response("leave:", status=200)
    except:
        return Response(status=400)

@app.route("/getPlayers")
def getPlayers():
    returnList = []
    for player in players:
        returnList.append(f"{player.name}:{player.id}:{player.position.x}:{player.position.y}:{player.currentGunID}")
    playerStr = str(returnList).replace("\'", "").replace("[", "").replace("]", "").replace(",", "\n")
    return Response(f'getPlayers:{playerStr}')

@app.route("/getPlayerFromID")
def getPlayerFromIDRequest():
    id = request.args["id"]
    for player in players:
        if player.id == id:
            Response(f"getPlayerFromID:{player.name}:{player.id}:{player.position.x}:{player.position.y}:{player.currentGunID}")
    return Response(status=400)

@app.route("/updatePlayer")
def updatePlayer():
    id = request.args["id"]
    x = request.args["x"]
    y = request.args["y"]
    rotation = request.args["rotation"]
    getPlayerFromID(id).setLastPacketTime()
    getPlayerFromID(id).getPosition().setY(y)
    getPlayerFromID(id).getPosition().setX(x)
    getPlayerFromID(id).rotation = rotation
    return Response(status=200)

@app.route("/fireBullet")
def fireBullet():
    x = request.args["x"]
    y = request.args["y"]
    rotation = request.args["rotation"]
    bullet: Bullet = Bullet(x, y, rotation)
    bullets.append(bullet)
    return Response(status=200)

@app.route("/changeGun")
def changeGun():
    id = request.args["id"]
    gunID = request.args["gunID"]
    getPlayerFromID(id).currentGunID = gunID
    return Response(status=200)

@app.route("/getBullets")
def getBullets():
    returnList = []
    for bullet in bullets:
        returnList.append(f"{bullet.position.x}:{bullet.position.y}:{bullet.rotation}")
    bulletStr = str(returnList).replace("[", "").replace("]", "").replace(",", "\n")
    return Response(bulletStr, status=200)

def main():
    while-True:
        for player in players:
            if time() - player.getLastPacketTime() > 2:
                print(f"{player.name} is {time() - player.getLastPacketTime()}s behind")
            if time() - player.getLastPacketTime() > 30:
                print(f"Removeing {player.name} due to timeout")
                players.remove(player)
        
        for bullet in bullets:
            bullet.update()

_thread.start_new_thread(main, ())
app.run(ip, port)