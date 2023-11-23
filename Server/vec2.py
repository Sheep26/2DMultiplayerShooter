class Vec2:
    x: float
    y: float
    
    def __init__(self, x: float, y: float):
        self.x = x
        self.y = y
        
    def getX(self) -> float:
        return self.x
    
    def getY(self) -> float:
        return self.y
    
    def setX(self, x):
        self.x = x
    
    def setY(self, y):
        self.y = y