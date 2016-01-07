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
def setSpace( parameters ):
    """
    # Creating x, y 
    x = Int('x')
    y = Int('y')
    
    # Creating the formula using Python
    f = And(x == y, Not(x == y))
    print f
    
    # Using eval to parse the string.
    s = "And(x == y, Not(x == y))"
    f2 = eval(s)
    print f2
    """
    
    s = "z3.And("
    params = []
    for p in parameters:
        pp = z3.Real( p[0] )
        p.append( pp )

    for p in parameters:
        interv = p[1].split( ".." )
        s += p[2] + ">=" + interv[0] + ", " + p[2] + " <=" + interv[1]
#        s += pp + ">=" + interv[0] + ", " + pp + " <=" + interv[1]
        if not p == parameters[-1]:
            s += ", "
    s += ")"
    print s
    f = eval( s )
    return f

def main( argv ):
    cons = constraints.getConstraints( argv[1] )
    print cons
    param = constraints.getParameters( argv[1] )
    print param
    setSpace( param )
    return

if __name__ == "__main__":
    if len( sys.argv ) < 2:
        printUsage( sys.argv )
        exit( -1 )
    main( sys.argv )
        
