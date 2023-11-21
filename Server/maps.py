class Map:
    name: str
    id: int
    path: str
    
    def __init__(self, name: str, id: int, path: str):
        self.name = name
        self.id = id
        self.path = path
        
level1: Map = Map("level1", 1, "")