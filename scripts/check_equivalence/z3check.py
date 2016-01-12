#!/usr/bin/env python

#from z3 import Or, And, Implies, ForAll
#from z3 import Ints
#from z3 import solve

import sys
import z3

import constraints

def printUsage( argv ):
        print "Missing args"
        print "Usage:"
        print "\t", argv[0], "<file1> <file2>"
        return

def tabToSpace( param ):
        space = "z3.And("
        s_string = []
        for p in param:
                var = p[0]
                interval = p[1]
                bounds = interval.split( ".." )
                s_interval = var + " >= " + bounds[0] + ", " + var + " <= "+ bounds[1]
                s_string.append( s_interval )
        space += ", ".join( s_string )
        space += ")"
        return space

def tabToConstrains( t_in ):
        t_out = []
        for t in t_in:
                c = t.split( " & " )
                c = ", ".join( c )
                constraint = "z3.And(" + c + ")"
                t_out.append( constraint )
        return t_out

def getTableOfConstraints( filename ):
        cons = constraints.getConstraints( filename )
        c = tabToConstrains( cons )
        return c

def getVariableNames( filename ):
        tab = []
        param = constraints.getParameters( filename )
        for p in param:
                tab.append( p[0] )
        return tab

def getParameterSpace( filename ):
        param = constraints.getParameters( filename )
        s = tabToSpace( param )
        return s

def declareRealVariables( filename ):
        tab = getVariableNames( filename )
        symb = []
        for t in tab:
                print "Declare", t
                s = z3.Real( t )
                symb.append( s )
                globals()[t] = s
        return symb

def applyOr( tab ):
        cons = "z3.Or(" + ", ".join( tab ) + ")"
        return cons

def Not( cons ):
        cons = "z3.Not(" + cons + ")"
        return cons

def check_equiv( f, g ):
        solv = z3.Solver()
        formula = eval( f + " <> " + g )
        solv.append( formula )
        return solv.check() == z3.unsat

def check_inclusion( f, g ):
        solv = z3.Solver()
        formula = eval( f )
        solv.append( formula )
        gormula = eval( Not( g ) )
        solv.append( gormula )
        return solv.check() == z3.unsat

def check_inclusion_witness( f, g ):
        solv = z3.Solver()
        formula = eval( f )
        solv.append( formula )
        gormula = eval( Not( g ) )
        solv.append( gormula )
        if solv.check() == z3.sat:
                print solv.model()
        return

def main( argv ):
        z3carto = getTableOfConstraints( argv[1] )
        vanilla = getTableOfConstraints( argv[2] )
        space = getParameterSpace( argv[1] )
        symbols = declareRealVariables( argv[1] )

        print " =-=-= CARTOZ3 =-=-="
        print check_equiv( applyOr( z3carto ), space )
        print check_inclusion( applyOr( z3carto ), space)
        check_inclusion_witness( applyOr( z3carto ), space )

        print " =-=-= VANILLA =-=-="
        print check_equiv( applyOr( vanilla ), space )
        print check_inclusion( applyOr( vanilla ), space)
        check_inclusion_witness( applyOr( vanilla ), space )
        return

if __name__ == "__main__":
    if len( sys.argv ) < 2:
        printUsage( sys.argv )
        exit( -1 )
    main( sys.argv )
        
