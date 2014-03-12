#!/usr/bin/env python2

import os
import sys
import mpd

class Player(object):
	def __init__(self):
		self.client=mpd.MPDClient()
		self.client.connect("localhost", 6600)
	def next(self):
		self.client.next()
	def previous(self):
		self.client.previous()
	def play(self):
		self.client.play()
	def pause(self):
		self.client.pause()
	def stop(self):
		self.client.stop()
	def close(self):
		self.client.close()
	def getcommand(self):
		try:
			self.command = sys.argv[1]
		except:
			print( "Error")
	def doit(self):
		if self.command == "-next":
			self.next()
		if self.command == "-previous":
			self.previous()
		if self.command == "-play":
			self.play()
		if self.command == "-pause":
			self.pause()
		if self.command == "-stop":
			self.stop()

a=Player()
a.getcommand()
a.doit()
a.close()
