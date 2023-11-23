from maps import Map
from time import time
from requests import get
from vec2 import Vec2

class Player:
    name: str
    position: Vec2
    currentGunID: int
    id: int
    map: Map
    ip: str
    lastPacketTime: int
    rotation: int
    
    def __init__(self, name: str, id: str, ip: str, map: Map):
        self.name = name
        self.id = id
        self.map = map
        self.position = Vec2(0, 0)
        self.currentGunID = 1
        self.ip = ip
        self.lastPacketTime = time
        self.rotation = 0
        
    def setLastPacketTime(self):
        self.lastPacketTime = time()
        
    def getLastPacketTime(self) -> int:
        return self.lastPacketTime
    
    def sendData(self, packet: str):
        get(f"{self.ip}/"+packet)
    
    def getPosition(self) -> Vec2:
        return self.position
    
    def setPosition(self, position: Vec2):
        self.position = position
    
    def setRotation(self, rotation: int):
        self.rotation = rotation
        
    def getRotation(self) -> int:
        return self.rotation
