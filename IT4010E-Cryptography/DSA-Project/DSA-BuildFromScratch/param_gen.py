from utils import miller_rabin, sam
import random

def param_gen(N=160, L=1024, H=160):
    rand = random.SystemRandom()
    q = 0
    while True:
        q = rand.randint(2**(N - 2) + 1, 2**(N - 1))
        q = q*2 - 1
        if miller_rabin(q):
            break
    p = 0
    while True:
        a = rand.randint(2**(L - N - 1), 2**(L - N) - 1)
        p = a * q + 1
        if p % 2 != 0 and 2**(L - 1) <= p <= 2**(L) - 1:
            if miller_rabin(p):
                break
    h = rand.randint(2, p - 2)
    g = sam(h, (p - 1) // q, p)
    while g == 1:
        h = rand.randint(2, p - 2)
        g = sam(h, (p - 1) // q, p)
    with open("public/parameters.txt", "w") as f:
        f.writelines([bin(p)[2:] + "\n", bin(q)[2:] + "\n", bin(g)[2:] + "\n"])
    return "Parameter has been generated"

if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument("--N", type=int, default=160)
    parser.add_argument("--L", type=int, default=1024)
    parser.add_argument("--H", type=int, default=160)
    opt = parser.parse_args()
    print(param_gen(opt.N, opt.L, opt.H))