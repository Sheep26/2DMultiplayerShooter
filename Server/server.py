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

# Initalizing config
with open("config.json", "r") as configFile:
    config = json.load(configFile)

name: str = config["generalSettings"]["serverName"]
maxPlayers: int = int(config["generalSettings"]["maxPlayers"])
ip: str = "0.0.0.0"
port: str = config["networkSettings"]["serverPort"]
currentMap: Map = Map(config["maps"][config["generalSettings"]["currentMap"]]["name"], config["maps"][config["generalSettings"]["currentMap"]]["pathOnServer"], config["maps"][config["generalSettings"]["currentMap"]]["pathOnClient"], config["maps"][config["generalSettings"]["currentMap"]]["startX"], config["maps"][config["generalSettings"]["currentMap"]]["startY"])

app = Flask(__name__)

# Set logging level
log = logging.getLogger('werkzeug')
log.setLevel(logging.ERROR)

def getPlayerFromID(id: int) -> Player:
    # Cycle through every player connected
    for player in players:
        # Check if player id matches given id
        if player.id == id:
            return player
    return None

@app.route("/")
def default():
    Response(name)

@app.route("/join")
def join():
    # Check if the max amount of players reached and deny connection if max amount of players reached
    if len(players) >= maxPlayers:
        return Response("Max Players Reached", 423)
    # Get the name of the joining player
    playerName = request.args["name"]
    id = ""
    # Generate their player id
    for n in range(9):
        id += str(randint(0, 9))
    # Make the player object and set position
    player = Player(playerName, id, request.remote_addr, currentMap)
    player.setLastPacketTime()
    player.setPosition(currentMap.spawnPosition.x, currentMap.spawnPosition.y)
    players.append(player)
    print(f"{playerName} joined the game")
    # Return the player data to the client
    return Response(f"join:{name}:{currentMap.pathOnClient}:{currentMap.pathOnServer}:{currentMap.name}:{player.name}:{player.id}:{player.position.x}:{player.position.y}", status=200)

@app.route("/leave")
def leave():
    # Get the leaving player id
    id = request.args["id"]
    try:
        # Get the player
        player = getPlayerFromID(id)
        # Remove them from the game
        players.remove(player)
        print(f"{player.name} left the game")
        return Response("leave:", status=200)
    except:
        return Response(status=400)

@app.route("/getPlayers")
def getPlayers():
    returnList = []
    # Cycle through every player connected
    for player in players:
        # Add their data to a list
        returnList.append(f"{player.name}:{player.id}:{player.position.x}:{player.position.y}:{player.currentGunID}")
    # Convert list to a string and format
    playerStr = str(returnList).replace("\'", "").replace("[", "").replace("]", "").replace(",", "\n")
    # Return that data to the client
    return Response(f'getPlayers:{playerStr}')

@app.route("/getPlayerFromID")
def getPlayerFromIDRequest():
    # Get the player id
    id = request.args["id"]
    # Cycle through every player connected
    for player in players:
        # Check if player id matches given id
        if player.id == id:
            # Return that player data to the client
            Response(f"getPlayerFromID:{player.name}:{player.id}:{player.position.x}:{player.position.y}:{player.currentGunID}")
    return Response(status=400)

@app.route("/updatePlayer")
def updatePlayer():
    # Get the players data
    id = request.args["id"]
    x = request.args["x"]
    y = request.args["y"]
    rotation = request.args["rotation"]
    # Set the data on the server
    getPlayerFromID(id).setLastPacketTime()
    getPlayerFromID(id).getPosition().setY(y)
    getPlayerFromID(id).getPosition().setX(x)
    getPlayerFromID(id).rotation = rotation
    return Response(status=200)

@app.route("/fireBullet")
def fireBullet():
    # Get bullet data
    x = request.args["x"]
    y = request.args["y"]
    rotation = request.args["rotation"]
    # Make bullet object and add to list
    bullet: Bullet = Bullet(x, y, rotation)
    bullets.append(bullet)
    return Response(status=200)

@app.route("/changeGun")
def changeGun():
    # Get player and gun id
    id = request.args["id"]
    gunID = request.args["gunID"]
    # Change gun
    getPlayerFromID(id).currentGunID = gunID
    return Response(status=200)

@app.route("/getBullets")
def getBullets():
    returnList = []
    # Cycle through every bullet
    for bullet in bullets:
        # Add them to a list
        returnList.append(f"{bullet.position.x}:{bullet.position.y}:{bullet.rotation}")
    # Convert the list to a string and then format
    bulletStr = str(returnList).replace("[", "").replace("]", "").replace(",", "\n")
    return Response(bulletStr, status=200)

@app.route("/map")
def map():
    # Download map
    mapPath = request.args["mapPath"]
    return send_from_directory("Maps", mapPath)

def main():
    # Printing info
    print(f"Server running on {socket.gethostbyname(socket.gethostname())}:{port}")
    print(f"Server running on map {currentMap.name}")
    while-True:
        # Check player connection
        for player in players:
            if time() - player.getLastPacketTime() > 2:
                print(f"{player.name} is {time() - player.getLastPacketTime()}s behind")
            if time() - player.getLastPacketTime() > 30:
                print(f"Removeing {player.name} due to timeout")
                players.remove(player)
        
        # Calculate bullet position
        for bullet in bullets:
            bullet.update()

# Run the server
_thread.start_new_thread(main, ())
app.run(ip, port)