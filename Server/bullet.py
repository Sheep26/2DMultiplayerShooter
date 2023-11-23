from math import cos, sin
from vec2 import Vec2

class Bullet:
    position: Vec2
    rotation: int
    rotationToVec2: Vec2

    def __init__(self, x: int, y: int, rotation: int):
        self.position = Vec2(x, y)
        self.rotation = rotation

    def update(self):
        rotationToVec2 = Vec2(cos(self.rotation), sin(self.rotation))
        self.position.x = rotationToVec2.x * 10
        self.position.y = rotationToVec2.y * 10