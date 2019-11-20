import extract_numbers
import plot

#data = open('/Users/ruzanna/Python_pr/bla.txt').readlines()

with open('/Users/ruzanna/Python_pr/bla.txt') as file:
    d = file.readlines()

my_numbers = extract_numbers.extract(d)
plot.plo(my_numbers)

#import time

#name = input()
#start_time = time.time()
#print('Hello, ', name, '!', sep='')

#print("--- %s seconds ---" % (time.time() - start_time))
