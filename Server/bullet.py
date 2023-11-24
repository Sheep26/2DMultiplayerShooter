from math import cos, sin
from vec2 import Vec2

class Bullet:
    shooterID: int
    position: Vec2
    rotation: float
    rotationToVec2: Vec2

    def __init__(self, shooterID: int, x: float, y: float, rotation: float):
        self.position = Vec2(x, y)
        self.rotation = rotation
        self.shooterID = shooterID

    def update(self):
        rotationToVec2 = Vec2(cos(self.rotation), sin(self.rotation))
        self.position.x = rotationToVec2.x * 10
        self.position.y = rotationToVec2.y * 10