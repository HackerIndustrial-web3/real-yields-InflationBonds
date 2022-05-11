


x = 1000
y = 5000

exchangeFee = 0.03
inflation = 0


k = (x * y) + inflation



def getNewY(_x):
    y = k/ _x
    return y

def getNewX(_y):
    x = k/ _y
    return x


def getPriceTrade(_x):
    new = _x
    fee = _x * exchangeFee
    deposit = _x - fee
    newY = getNewY(deposit)
    y - k
