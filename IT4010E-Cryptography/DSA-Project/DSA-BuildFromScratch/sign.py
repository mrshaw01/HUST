from utils import sha1, ExtEuclid, sam
import random

def sign(doc_dir, param_dir, private_dir):
    with open(private_dir, "r") as f:
        x = int(f.read(), base=2)
    with open(param_dir, "r") as f:
        p = int(f.readline()[:-1], base=2)
        q = int(f.readline()[:-1], base=2)
        g = int(f.readline()[:-1], base=2)
    rand = random.SystemRandom()
    k = rand.randint(1, q - 1)
    r = sam(g, k, p) % q
    while r == 0:
        k = 15#
        r = sam(g, k, p) % q
    _, s, _ = ExtEuclid(k, q)
    if s < 0:
        s = s + q
    s = (s * ((sha1(doc_dir) + x*r) % q)) % q
    while s == 0:
        _, s, _ = ExtEuclid(k, q)
        if s < 0:
            s = s + q
        s = (s * ((sha1(doc_dir) + x*r) % q)) % q
    with open("signature.txt", "w") as f:
        f.writelines([bin(r)[2:] + "\n", bin(s)[2:]])
    return "Document signed, signature in signature.txt"

if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument("--doc_dir", type=str, default="contract.txt")
    parser.add_argument("--param_dir", type=str, default="Public/parameters.txt")
    parser.add_argument("--private_dir", type=str, default="Private/private.txt")
    opt = parser.parse_args() 
    print(sign(opt.doc_dir, opt.param_dir, opt.private_dir))