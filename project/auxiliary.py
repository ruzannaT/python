
import optional


def second_function(arg="empty string"):
    ''' Method prints its arg.
        @ arg is a string with...'''

    print(arg)


if __name__ == '__main__':

    print("auxiliary")

    optional.first_function()

    second_function(arg="full string")