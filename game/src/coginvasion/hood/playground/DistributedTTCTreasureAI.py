"""
COG INVASION ONLINE
Copyright (c) CIO Team. All rights reserved.

@file DistributedTTCTreasureAI.py
@author Maverick Liberty
@date July 15, 2015

"""

from .DistributedTreasureAI import DistributedTreasureAI

class DistributedTTCTreasureAI(DistributedTreasureAI):

    def __init__(self, air, treasurePlanner = None, x = 0, y = 0, z = 0):
        DistributedTreasureAI.__init__(self, air, treasurePlanner, x, y, z)
