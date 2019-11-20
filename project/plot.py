import matplotlib.pyplot as plt

def plo(data):

    x = data[:int(len(data)/2)]
    y = data[int(len(data)/2):]
    plt.plot(x,y, 'ro')
    plt.show()

if __name__ == '__main__':

    plo()