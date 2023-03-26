import os
import time
from Crypto.PublicKey import DSA

global_time = time.time()

try:
    # Generate a new DSA key pair
    key = DSA.generate(1024)

    # Get signers
    print("=" * 100)
    signers = []
    for file_name in os.listdir("keys"):
        if "_private_key.pem" in file_name:
            signers.append(file_name.split("_private_key")[0])
    print(f"Signers: {signers}")

    # Signer
    print("=" * 100)
    signer = input("New signer: ")
    if signer in signers:
        raise Exception("This signer has his own keys")

    # Serialize the private key to a file
    print("=" * 100)
    private_key = key.export_key()
    print(f"Generated private key: {private_key}")
    with open(f"./keys/{signer}_private_key.pem", "wb") as f:
        f.write(private_key)

    # Serialize the public key to a file
    print("=" * 100)
    public_key = key.publickey().export_key()
    with open(f"./keys/{signer}_public_key.pem", "wb") as f:
        f.write(public_key)
    print(f"Generated public key: {public_key}")
except Exception as e:
    print(e)
print("=" * 100)
print(f"Program finished, total time = {round(time.time() - global_time)}s!!!")
