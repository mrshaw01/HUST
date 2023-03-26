from utils import sam
import random

def keygen(param_dir):
    with open(param_dir, "r") as f:
        p = int(f.readline()[:-1], base=2)
        q = int(f.readline()[:-1], base=2)
        g = int(f.readline()[:-1], base=2)
    rand = random.SystemRandom()
    x = rand.randint(1, q - 1)
    y = sam(g, x, p)
    with open("Private/private.txt", "w") as f:
        f.write(bin(x)[2:])
    with open("Public/public.txt", "w") as f:
        f.write(bin(y)[2:])
    return "Public and private key generated"
            
            
if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument("--param_dir", type=str, default="Public/parameters.txt")
    opt = parser.parse_args()
    print(keygen(opt.param_dir))