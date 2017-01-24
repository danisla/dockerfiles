#!/usr/bin/env python

import mutagen, mutagen.id3
import glob
import os
import shlex
import sys

for file in glob.glob('*.mp3'):
	id3 = mutagen.id3.ID3(file,translate=True)
	valid_file = True
	for required_field in ['TPE1','TRCK','TIT2']:
		if not id3.has_key(required_field):
			if required_field == "TPE1":
				if not id3.has_key("TPE2"):
					print "ERROR: %s missing field: %s and %s" % (file, "TPE1","TPE2")
			else:	
				print "ERROR: %s missing field: %s" % (file, required_field)
			valid_file = False
	if valid_file == True:
		trck = id3.get('TRCK').text[0]
		if "/" in trck:
			track_num = int(trck.split("/")[0])
		else:
			track_num = int(trck)
		artist = id3.get('TPE1').text[0].strip()
		if artist == "":
			artist = id3.get('TPE2').text[0].strip()
		title = id3.get('TIT2').text[0].strip()
		dest_file = "%02d. %s - %s.mp3" % (track_num,artist,title)
		dest_file = dest_file.replace("/","-")
		print "New file: %s" % (dest_file)
		os.rename(file,dest_file)
	else:
		sys.exit(1)

