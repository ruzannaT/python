import plot
import re

def extract(data):

    numbers = []
    k = 0
    l = []

    for i in range(0, len(data)):

        st = str(data[i])
        n = [int(s) for s in re.findall(r'\b\d+\b', st)]
        numbers.append(n)

        while k < len(numbers):
            l = l + numbers[k]
            k = k + 1


    return l

if __name__ == '__main__':

    extract()

