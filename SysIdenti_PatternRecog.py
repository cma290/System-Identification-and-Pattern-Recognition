# -*- coding: utf-8 -*-
"""
Created on Thu Apr 10 23:44:56 2014

@author: macheng
"""


import numpy as np
from scipy.optimize import leastsq


x1list = open('X1.txt').read().split()
x1list .pop(999999)
x1list .pop(999998)

x1list1 = open('X1.txt').read().split()
x1list1.pop(999999) #k-1
x1list1.pop(0)

x1list2 = open('X1.txt').read().split()
x1list2.pop(0) # k -2
x1list2.pop(0) 

x2list = open('X2.txt').read().split()
x2list .pop(999999)
x2list .pop(999998)

x2list1 = open('X2.txt').read().split()
x2list1.pop(999999)#k-1
x2list1.pop(0)

x2list2 = open('X2.txt').read().split()
x2list2.pop(0)#k-2
x2list2.pop(0)

ylist = open('Y.txt').read().split()
# before poping, do the error counting first
index = 1
stack = 1 # count the number in consecutice increase
count = 0
while index < 1000000 :
    if (ylist[index-1] > ylist[index]): 
        stack +=1
    else:stack = 0
    
    if stack >=6 :
        count = count+1
    index += 1    

print 'error count = ', count            

ylist .pop(999999) # k=999999 to k = 2
ylist .pop(999998)

x1arr= np.asarray(x1list, dtype=float) # list to array
x1arr1= np.asarray(x1list1, dtype=float) # list to array
x1arr2= np.asarray(x1list2, dtype=float) # list to array

x2arr= np.asarray(x2list,dtype=float)
x2arr1= np.asarray(x2list1,dtype=float)
x2arr2= np.asarray(x2list2,dtype=float)

yarr= np.asarray(ylist,dtype=float)

def fun(x1,x2,x1_1,x2_1,x1_2,x2_2, p):
    a0, b0,a1,b1,a2,b2= p
    return a0*x1 + b0*x2 + a1*x1_1 + b1*x2_1 + a2*x1_2 + b2*x2_2

def residuals(p, x1,x2, x1_1,x2_1, x1_2,x2_2, y):
    return fun(x1,x2, x1_1,x2_1, x1_2,x2_2, p) - y

r = leastsq(residuals, [1,2,3,4,5,6], args=(x1arr,x2arr, x1arr1,x2arr1,x1arr2,x2arr2, yarr))

print r[0]

v = yarr - (10*x1arr +2.5* x1arr1 - x1arr2 + x2arr +0.1*x2arr1)
print  np.mean(v), np.std (v)

 