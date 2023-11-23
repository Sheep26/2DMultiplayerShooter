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
    lastPacketTime: int
    gunRotation: int
    
    def __init__(self, name: str, id: str, ip: str, map: Map):
        self.name = name
        self.id = id
        self.map = map
        self.x = 0
        self.y = 0
        self.currentGunID = 1
        self.ip = ip
        self.lastPacketTime = time
        self.gunRotation = 0
        
    def setLastPacketTime(self):
        self.lastPacketTime = time()
        
    def getLastPacketTime(self) -> int:
        return self.lastPacketTime
    
    def sendData(self, packet: str):
        get(f"{self.ip}/"+packet)
    
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
