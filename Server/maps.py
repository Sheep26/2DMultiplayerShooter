class Map:
    name: str
    id: int
    path: str
    spawnX: float
    spawnY: float
    
    def __init__(self, name: str, id: int, path: str, spawnX: float, spawnY: float):
        self.name = name
        self.id = id
        self.path = path
        self.spawnX = spawnX
        self.spawnY = spawnY
        
level1: Map = Map("level1", 1, "res://Scenes/Levels/Level1.tscn", 562, 246)
Maps = [level1]