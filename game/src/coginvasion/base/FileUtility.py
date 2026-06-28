"""
COG INVASION ONLINE
Copyright (c) CIO Team. All rights reserved.

@file FileUtility.py
@author Brian Lach
@date April 18, 2015

"""

from panda3d.core import VirtualFileSystem, Filename
vfs = VirtualFileSystem.getGlobalPtr()

def handleFileList(models, fileList):
	# macOS port: vfs.scanDirectory returns None for a path that isn't a directory in the
	# VFS (e.g. an unpacked phase that doesn't exist); skip instead of crashing. # -- macOS port
	if fileList is None:
		return
	for fileName in fileList:
		fullPath = fileName.get_filename().get_fullpath()
		if fullPath.endswith(('.bam', 'egg', '.pz')):
			if not fullPath in models:
				models.append(fullPath)
		else:
			handleFileList(models, vfs.scanDirectory(Filename(fullPath)))

def findAllModelFilesInVFS(phase_array):
	models = []
	for phase in phase_array:
		fileList = vfs.scanDirectory(Filename(phase))
		handleFileList(models, fileList)
	return models
