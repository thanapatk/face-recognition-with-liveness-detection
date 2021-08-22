from __future__ import annotations
from typing import Tuple
import cv2
import numpy as np

class Point:
    def __init__(self, x: int, y: int):
        self.x = x
        self.y = y

    def __add__(self, other: Point) -> Point:
        return Point(self.x + other.x, self.y + other.y)

    def toTuple(self) -> Tuple:
        return (self.x, self.y)


def rounded_rectangle(src: np.array, top_left: Point, bottom_right: Point, cornerRadius: int = 10, color: tuple = (255,255,255), thickness: int = 1, lineType=cv2.LINE_AA):
    #  corners:
    #  p1 - p2
    #  |     |
    #  p4 - p3

    p1 = top_left
    p2 = Point(bottom_right.x, top_left.y)
    p3 = bottom_right
    p4 = Point(top_left.x, bottom_right.y)

    # Fill
    if thickness < 0:
        #main rect 
        main_rect = [Point(p1.x + cornerRadius, p1.y), Point(p3.x - cornerRadius, p3.y)]
        left_rect = [Point(p1.x + cornerRadius, p1.y + cornerRadius), Point(p4.x, p4.y - cornerRadius)]
        right_rect = [Point(p2.x - cornerRadius, p2.y + cornerRadius), Point(p3.x, p3.y - cornerRadius)]

        [cv2.rectangle(src, rect[0].toTuple(), rect[1].toTuple(), color, thickness) for rect in [main_rect, left_rect, right_rect]]

    # Outline
    cv2.line(src, (p1.x+cornerRadius,p1.y), (p2.x-cornerRadius,p2.y), color, abs(thickness), lineType);
    cv2.line(src, (p2.x,p2.y+cornerRadius), (p3.x,p3.y-cornerRadius), color, abs(thickness), lineType);
    cv2.line(src, (p4.x+cornerRadius,p4.y), (p3.x-cornerRadius,p3.y), color, abs(thickness), lineType);
    cv2.line(src, (p1.x,p1.y+cornerRadius), (p4.x,p4.y-cornerRadius), color, abs(thickness), lineType);

    # Arc
    cv2.ellipse(src, (p1+Point(cornerRadius, cornerRadius)).toTuple(), (cornerRadius, cornerRadius), 180.0, 0, 90, color, thickness, lineType);
    cv2.ellipse(src, (p2+Point(-cornerRadius, cornerRadius)).toTuple(), (cornerRadius, cornerRadius), 270.0, 0, 90, color, thickness, lineType);
    cv2.ellipse(src, (p3+Point(-cornerRadius, -cornerRadius)).toTuple(), (cornerRadius, cornerRadius), 0.0, 0, 90, color, thickness, lineType);
    cv2.ellipse(src, (p4+Point(cornerRadius, -cornerRadius)).toTuple(), (cornerRadius, cornerRadius), 90.0, 0, 90, color, thickness, lineType);

    return src