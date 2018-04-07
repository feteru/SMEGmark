while(1):
	fname = 'outFile.txt'
	with open(fname, 'r') as fin:
		print fin.read()
		fin.close()