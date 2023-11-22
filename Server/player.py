from maps import Map
from time import time
from requests import get

class Player:
    name: str
    x: int
    y: int
    currentGunID: int
    id: int
    map: Map
    ip: str
    alive: int
    gunRotation: int
    
    def __init__(self, name: str, id: str, ip: str, map: Map):
        self.name = name
        self.id = id
        self.map = map
        self.x = 0
        self.y = 0
        self.currentGunID = 1
        self.ip = ip
        self.alive = time
        self.gunRotation = 0
        
    def setAlive(self):
        self.alive = time()
        
    def getAlive(self) -> int:
        return self.alive
    
    def sendPacket(self, packet: str):
        get(f"{self.ip}/packet")
        
    def setX(self, x: int):
        self.x = x
    
    def setY(self, y: int):
        self.y = y
    
    def getX(self) -> int:
        return self.x
    
    def getY(self) -> int:
        return self.y
    
    def setRotation(self, rotation: int):
        self.rotation = rotation
        
    def getRotation(self) -> int:
        return self.rotation
