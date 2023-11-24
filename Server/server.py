from flask import Flask
from flask import request
from flask import Response
from flask import send_from_directory
import json
from player import Player
from random import randint
from maps import Map
import _thread
from time import time
from time import sleep
import logging
from bullet import Bullet
from typing import List
import socket

players: List[Player] = list()
bullets: List[Bullet] = list()
Maps: List[Map] = list()

with open("config.json", "r") as configFile:
    config = json.load(configFile)

name: str = config["generalSettings"]["serverName"]
maxPlayers: int = int(config["generalSettings"]["maxPlayers"])
ip: str = "0.0.0.0"
port: str = config["networkSettings"]["serverPort"]
for map in config["maps"]:
    mapName = config["maps"][map]["name"]
    mapPathOnServer = config["maps"][map]["pathOnServer"]
    mapPathOnClient = config["maps"][map]["pathOnClient"]
    mapStartX = float(config["maps"][map]["startX"])
    mapStartY = float(config["maps"][map]["startY"])
    Maps.append(Map(mapName, mapPathOnServer, mapPathOnClient, mapStartX, mapStartY))
currentMap: Map = Maps[0]

app = Flask(__name__)

log = logging.getLogger('werkzeug')
log.setLevel(logging.ERROR)

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
    global currentMap
    mapName = request.args["map"]
    for map1 in Maps:
        if map1.name == mapName:
            currentMap = map1

@app.route("/getMap")   
def getMap():
    return Response(f"{currentMap}")

@app.route("/join")
def join():
    if len(players) >= maxPlayers:
        return Response("Max Players Reached", 423)
    playerName = request.args["name"]
    id = ""
    for n in range(9):
        id += str(randint(0, 9))
    player = Player(playerName, id, request.remote_addr, currentMap)
    player.setLastPacketTime()
    player.setPosition(currentMap.spawnPosition.x, currentMap.spawnPosition.y)
    players.append(player)
    print(f"{playerName} joined the game")
    return Response(f"join:{name}:{currentMap.pathOnClient}:{currentMap.pathOnServer}:{currentMap.name}:{player.name}:{player.id}:{player.position.x}:{player.position.y}", status=200)

@app.route("/leave")
def leave():
    id = request.args["id"]
    try:
        player = getPlayerFromID(id)
        players.remove(player)
        print(f"{player.name} left the game")
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

@app.route("/map")
def map():
    mapPath = request.args["mapPath"]
    return send_from_directory("Maps", mapPath)

def main():
    print(f"Server running on {socket.gethostbyname(socket.gethostname())}:{port}")
    while-True:
        for player in players:
            if time() - player.getLastPacketTime() == 2:
                print(f"{player.name} is {time() - player.getLastPacketTime()}s behind")
            if time() - player.getLastPacketTime() == 5:
                print(f"{player.name} is {time() - player.getLastPacketTime()}s behind")
            if time() - player.getLastPacketTime() == 30:
                print(f"Removeing {player.name} due to timeout")
                players.remove(player)
        
        for bullet in bullets:
            bullet.update()

_thread.start_new_thread(main, ())
app.run(ip, port)