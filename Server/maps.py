from vec2 import Vec2

class Map:
    name: str
    id: int
    pathOnServer: str
    pathOnClient: str
    spawnPosition: Vec2
    
    def __init__(self, name: str, id: int, pathOnServer: str, pathOnClient: str, spawnX: float, spawnY: float):
        self.name = name
        self.id = id
        self.pathOnServer = pathOnServer
        self.pathOnClient = pathOnClient
        self.spawnPosition = Vec2(spawnX, spawnY)