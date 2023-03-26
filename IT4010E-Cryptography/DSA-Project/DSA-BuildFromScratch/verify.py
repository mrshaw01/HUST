from utils import sha1, ExtEuclid, sam

def verify(doc_dir, signature_dir, param_dir, public_dir):
    with open(public_dir, "r") as f:
        y = int(f.read(), base=2)
    with open(param_dir, "r") as f:
        p = int(f.readline()[:-1], base=2)
        q = int(f.readline()[:-1], base=2)
        g = int(f.readline()[:-1], base=2)
    with open(signature_dir, "r") as f:
        r = int(f.readline()[:-1], base=2)
        s = int(f.readline(), base=2)
    if not (0 < r < q and 0 < s < q):
        return "The signature does not match the document and signer."
    else:
        w = sam(s, q - 2, q)
        u1 = (sha1(doc_dir) * w) % q
        u2 = (r * w) % q
        v = ((sam(g, u1, p) * sam(y, u2, p)) % p) % q
        if v == r:
            return "The signature match the document and the signer."
        else:
            return "The signature does not match the document and signer."

if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument("--doc_dir", type=str, default="contract.txt")
    parser.add_argument("--signature_dir", type=str, default="signature.txt")
    parser.add_argument("--param_dir", type=str, default="Public/parameters.txt")
    parser.add_argument("--public_dir", type=str, default="Public/public.txt")
    opt = parser.parse_args() 
    print(verify(opt.doc_dir, opt.signature_dir, opt.param_dir, opt.public_dir))