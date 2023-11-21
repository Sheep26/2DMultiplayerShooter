from maps import Map

class Player:
    name: str
    x: int
    y: int
    currentGunID: int
    id: int
    map: Map
    
    def __init__(self, name: str, id: str, map: Map):
        self.name = name
        self.id = id
        self.map = map
        self.x = 0
        self.y = 0
        self.currentGunID = 1
