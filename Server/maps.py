class Map:
    name: str
    id: int
    path: str
    spawnX: int
    spawnY: int
    
    def __init__(self, name: str, id: int, path: str, spawnX: int, spawnY: int):
        self.name = name
        self.id = id
        self.path = path
        self.spawnX = spawnX
        self.spawnY = spawnY
        
level1: Map = Map("level1", 1, "res://Scenes/Levels/Level1.tscn", 20, 20)
Maps = [level1]