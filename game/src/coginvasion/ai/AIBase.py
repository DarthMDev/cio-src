"""
COG INVASION ONLINE
Copyright (c) CIO Team. All rights reserved.

@file AIBase.py
@author Brian Lach
@date January 25, 2015

"""

import time

from direct.directnotify.DirectNotifyGlobal import directNotify
from direct.interval.IntervalManager import ivalMgr
from direct.showbase.BulletinBoardGlobal import *
from direct.showbase.EventManagerGlobal import *
from direct.showbase.JobManagerGlobal import *
from direct.showbase.MessengerGlobal import *
from direct.task import Task
from direct.task.TaskManagerGlobal import *

from panda3d.core import VirtualFileSystem, NodePath, GraphicsEngine
from panda3d.core import ClockObject, TrueClock, Notify, PandaNode
# macOS/py3 port: getConfigShowbase() was removed from modern panda; provide a tiny compat
# shim over ConfigVariable* (base.config.GetX is used across the AI code). # -- macOS port
from panda3d.core import ConfigVariableDouble, ConfigVariableBool, ConfigVariableInt, ConfigVariableString

class _ConfigCompat:
	def GetFloat(self, key, default=0.0): return ConfigVariableDouble(key, default).getValue()
	def GetBool(self, key, default=False): return ConfigVariableBool(key, default).getValue()
	def GetInt(self, key, default=0): return ConfigVariableInt(key, default).getValue()
	def GetString(self, key, default=""): return ConfigVariableString(key, default).getValue()

class AIBase:
	notify = directNotify.newCategory("AIBase")

	def __init__(self):
		self.config = _ConfigCompat()
		vfs = VirtualFileSystem.getGlobalPtr()
		self.eventMgr = eventMgr
		self.messenger = messenger
		self.bboard = bulletinBoard
		self.taskMgr = taskMgr
		self.AISleep = self.config.GetFloat('ai-sleep', 0.04)
		Task.TaskManager.taskTimerVerbose = self.config.GetBool('task-timer-verbose', 0)
		Task.TaskManager.extendedExceptions = self.config.GetBool('extended-exceptions', 0)
		self.sfxManagerList = None
		self.musicManager = None
		self.jobMgr = jobMgr
		self.hidden = NodePath('hidden')
		self.graphicsEngine = GraphicsEngine.getGlobalPtr()
		globalClock = ClockObject.getGlobalClock()
		self.trueClock = TrueClock.getGlobalPtr()
		globalClock.setRealTime(self.trueClock.getShortTime())
		globalClock.setAverageFrameRateInterval(30.0)
		globalClock.tick()
		taskMgr.globalClock = globalClock
		__builtins__['ostream'] = Notify.out()
		__builtins__['globalClock'] = globalClock
		__builtins__['vfs'] = vfs
		__builtins__['hidden'] = self.hidden
		self.restart()

	def __sleepCycleTask(self, task):
		time.sleep(self.AISleep)
		return Task.cont

	def __resetPrevTransform(self, state):
		PandaNode.resetAllPrevTransform()
		return Task.cont

	def __ivalLoop(self, state):
		ivalMgr.step()
		return Task.cont

	def __igLoop(self, state):
		self.graphicsEngine.renderFrame()
		return Task.cont

	def destroy(self):
		self.shutdown()

	def shutdown(self):
		AIBase.notify.info('Shutting down...')
		self.taskMgr.remove('ivalLoop')
		self.taskMgr.remove('igLoop')
		self.taskMgr.remove('aiSleep')
		self.eventMgr.shutdown()
		try:
			self.getRepository().shutdown()
		except:
			pass

	def restart(self):
		self.shutdown()
		self.taskMgr.add(self.__resetPrevTransform, 'resetPrevTransform', priority=-51)
		self.taskMgr.add(self.__ivalLoop, 'ivalLoop', priority=20)
		self.taskMgr.add(self.__igLoop, 'igLoop', priority=50)
		if self.AISleep >= 0:
			self.taskMgr.add(self.__sleepCycleTask, 'aiSleep', priority=55)
		self.eventMgr.restart()

	def getRepository(self):
		return self.air

	def run(self):
		self.taskMgr.run()
