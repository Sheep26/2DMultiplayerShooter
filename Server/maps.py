from vec2 import Vec2

class Map:
    name: str
    id: int
    path: str
    spawnPosition: Vec2
    
    def __init__(self, name: str, id: int, path: str, spawnX: float, spawnY: float):
        self.name = name
        self.id = id
        self.path = path
        self.spawnPosition = Vec2(spawnX, spawnY)
        
level1: Map = Map("level1", 1, "res://Scenes/Levels/Level1.tscn", 562, 246)
Maps = [level1]