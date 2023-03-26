import hashlib
import random

def sha1(directory):
    with open(directory, "rb") as f:
        txt = f.read()
    hashing = hashlib.sha1(txt)
    return int(hashing.hexdigest(), base=16)

def ExtEuclid(a, b):
    if b == 0:
        return a, 1, 0
    d1, s1, t1 = ExtEuclid(b, a%b)
    d = d1
    s = t1
    t = s1 - (a // b) * t1
    return d, s, t

def sam(x, exponent, n):
    z = 1
    x_bin = bin(exponent)[2:]
    for i in range(len(x_bin)):
        z = (z * z) % n 
        if int(x_bin[i]) == 1:
            z = (z * x) % n 
    return z

def factor_out(n):
    i = 0
    while n % 2 == 0:
        i += 1
        n = n // 2
    return i, n

def miller_rabin(n, k=10):
    if n <= 1:
        return False
    s, d = factor_out(n - 1)
    for i in range(k):
        a = random.randint(2, n - 2)
        x = sam(a, d, n)
        for j in range(s):
            y = sam(x, 2, n)
            if y == 1 and x != 1 and x != n - 1:
                return False
            x = y
        if x != 1:
            return False
    return True    