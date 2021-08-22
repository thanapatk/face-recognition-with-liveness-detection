from __future__ import annotations
from typing import Any, Tuple
import cv2
import numpy as np
from datetime import datetime
from PIL import Image, ImageFont, ImageDraw

user_img_offset = (60, 15)
text_offset = (40,10)
text_padding = 5

class Point:
    def __init__(self, x: int, y: int):
        self.x = x
        self.y = y

    def __add__(self, other: Point) -> Point:
        return Point(self.x + other.x, self.y + other.y)

    def toTuple(self) -> Tuple:
        return (self.x, self.y)


def rounded_rectangle(src: np.array, top_left: tuple, bottom_right: tuple, cornerRadius: int = 10, color: tuple = (255,255,255), thickness: int = 1, lineType: int=cv2.LINE_AA) -> Any:
    """Create a rounded rectangle

    Args:
        src (np.array): Image
        top_left (Point): Top left vertex of the rectangle
        bottom_right (Point): Bottom right vertex the rectangle
        cornerRadius (int, optional): The radius of the rounded corner. Defaults to 10.
        color (tuple, optional): Color of the rectangle. Defaults to (255,255,255).
        thickness (int, optional): Thickness of the line. Set to -1 to fills the rectangle. Defaults to 1.
        lineType (int, optional): Line Type. Defaults to cv2.LINE_AA.
    """
    #  corners:
    #  p1 - p2
    #  |     |
    #  p4 - p3

    p1 = Point(top_left[0], top_left[1])
    p2 = Point(bottom_right[0], top_left[1])
    p3 = Point(bottom_right[0], bottom_right[1])
    p4 = Point(top_left[0], bottom_right[1])

    # Fill
    if thickness < 0:
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


def userCard(src: np.array, alpha: float, top_left: tuple, bottom_right: tuple, background_color: tuple, foreground_color: tuple, identity: str, time: datetime, font_path: str, font_size: int=24) -> np.array:
    """Generate a user card to overlay on top of the src

    Args:
        src (np.array): the source (non-destructive).
        alpha (float): the amount that the picture will be dimmed [0.0-1.0].
        top_left (tuple): The top left vertex of the rectangle.
        bottom_right (tuple): The bottom right vertex of the rectangle.
        background_color (tuple): background color.
        foreground_color (tuple): forground color.
        identity (str): the identity of the user.
        time (datetime): time that user scans their face.
        font_path (str): the path to the font.
        font_size (int): font size. Defaults to 24.

    Returns:
        np.array: a new img that has the card overlay on top
    """
    
    img = src.copy()

    # dimmed the source
    img = cv2.addWeighted(img, alpha, np.zeros(img.shape, img.dtype), 1 - alpha, 0)
    
    # add background
    rounded_rectangle(img, top_left, bottom_right, color=background_color, thickness=-1)

    # add the user image to the card
    user_img_top_left = (top_left[1] + user_img_offset[1], top_left[0] + user_img_offset[0])
    user_img_path = f'face_pic/{identity}.jpg'

    user_img = cv2.imread(user_img_path)
    user_img = cv2.resize(user_img, (round(user_img.shape[1]*.25), round(user_img.shape[0]*.25)))

    user_img_size = user_img.shape
    
    img[user_img_top_left[0]:user_img_top_left[0]+user_img_size[0], user_img_top_left[1]:user_img_top_left[1]+user_img_size[1]] = user_img

    # add text
    text_top_left = (user_img_top_left[1]+user_img_size[1]+text_offset[0], user_img_top_left[0]+text_offset[1])
    
    time_str = time.strftime('%H:%M:%S')

    font = ImageFont.truetype(font_path, font_size)

    img_pil = Image.fromarray(img)
    draw = ImageDraw.Draw(img_pil)
    
    draw.text(text_top_left, f'เลขประจำตัว: {identity}', font=font, fill=foreground_color)
    draw.text((text_top_left[0], text_top_left[1] + font_size + text_offset[1] + text_padding), f'เวลา: {time_str}', font=font, fill=foreground_color)
    
    img = np.array(img_pil)

    return img 