class Player:
    name: str
    x: int
    y: int
    currentGunID: int
    id: int
    
    def __init__(self, name: str, id: str):
        self.name = name
        self.id = id