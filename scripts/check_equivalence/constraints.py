#!/usr/bin/env python

import sys
import z3

def printUsage( argv ):
        print "Missing args"
        print "Usage:"
        print "\t", argv[0], "<file1> <file2>"
        return

def extractConstraint( lines ):
	nb = lines[0].split()[0]
	end = len( lines ) - 1
	for idx in range( len( lines ) ):
		lines[idx] = lines[idx].split( "\n")[0]
	if "replace" in lines[-1]:
#		print "Replace", nb, "by", lines[-1].split( "replace" )[-1]#.split("\n")[0]
		nb = "K" + lines[-1].split( "replace" )[-1]#.split("\n")[0]
		end -= 1
	if "dropped" in lines[-1]:
#		print "Drop", nb
		nb = ""
		cons = ""
	else:
		cons = "".join( lines[1:end] )
		t = cons.split()
		cons = " ".join( t )
	return nb, cons

def getConstraints( filename ):
	tab = {}
	fd = open( filename, 'r' ) # je ne gere pas les exceptions parce que je fais cca rapidos
	lines = fd.readlines() # on chope tout d'un coup parce que ca ne va pas non plus etre monstrueux
	idx = 0
	while idx < len( lines ):
		if "computed by IM after" in lines[idx]:
			k = 0
			while not lines[idx+k].isspace() and idx < len( lines ):
				k += 1
			num, const = extractConstraint( lines[idx:idx+k] )
			if not "" == num:
				tab[num] = const
			idx += k
		idx += 1
	fd.close()
	res = sorted( tab.values() )
	return res

def printConstraints( t1, t2 ):
	for c in t1:
		print >> sys.stderr, c
	for c in t2:
		print >> sys.stdout, c
	return

def cleanConstraints( t1, t2 ):
	for c in t1:
		if c in t2:
			t2.remove( c )
	for c in t2:
		if c in t1:
			t1.remove( c )
	return

def getParameters( filename ):
	t = []
	fd = open( filename, 'r' ) 
	lines = fd.readlines() 
	idx = 0
	while idx < len( lines ):
		if "Parametric rectangle" in lines[idx]:
			idx +=1
			while not "Number of points inside V0" in lines[idx] and idx < len( lines ):
				p = (lines[idx].split( "=" )[0]).split( )[-1]
				boundaries = lines[idx].split( "=" )[1].split( "\n" )[0]
				t.append( ( p, boundaries ) )
				idx +=1
		idx += 1

	fd.close()
	return t

def main( argv ):
	t1 = getConstraints( argv[1] )
	t2 = getConstraints( argv[2] )
	cleanConstraints( t1, t2 )
	printConstraints( t1, t2 )
	print getParameters( argv[1] )
	return

if __name__ == "__main__":
	if len( sys.argv ) < 3:
		printUsage( sys.argv )
		exit( -1 )
	main( sys.argv )
