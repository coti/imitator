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
"""
def david():
    i,x,n,pos = Ints('i x n pos')

    precond = And(x>=0, x<n, pos>=0, pos<n)

    error = Or(And(n>=pos+1, x<=pos-1, x>=0),
               And(x>=pos+1, n>=x+2, pos>=0),
               And(n==x+1, x>=pos+1, pos>=0))

    error_q = And(precond, ForAll(x, Implies(precond, error)))

    solve(error_q) # no solution

    final = Or(
        And(pos==x, i<=x-1, i>=0, n>=x+1),
        And(i==x, i>=0, n>=pos+1, i<=pos-1),
        And(x>=pos+1, i<=x-1, i>=0, n>=x+1, pos>=0),
        And(i==x, i<=n-1, i>=pos+1, pos>=0),
        And(i>=x+1, n>=pos+1, i<=n-1, x<=pos-1, x>=0),
        And(i<=x-1, i>=0, n>=pos+1, x<=pos-1),
        And(i==x, i==pos, i>=0, i<=n-1),
        And(x>=pos+1, i>=x+1, i<=n-1, pos>=0))

    final_q = And(precond, ForAll(x, Implies(precond, final)))
    
    solve(And(final,i>pos))
    solve(final_q)
    solve(And(i>pos, n>0, ForAll(x, Implies(And(0<=x, x<n), final))))
    solve(And(final_q, i>pos))
    return
"""
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

def main( argv ):
        solv = z3.Solver()
        c = getTableOfConstraints( argv[1] )
        s = getParameterSpace( argv[1] )
        symbols = declareRealVariables( argv[1] )
        F = eval( s )
        return

if __name__ == "__main__":
    if len( sys.argv ) < 2:
        printUsage( sys.argv )
        exit( -1 )
    main( sys.argv )
        
