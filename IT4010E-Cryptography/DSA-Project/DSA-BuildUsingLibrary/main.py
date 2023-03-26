import os
from Crypto.Signature import DSS
from Crypto.Hash import SHA256
from Crypto.PublicKey import DSA

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
signer = input("Signer: ")
if signer not in signers:
    raise Exception("Not valid this signer")

# Load the private key from the file
with open(f"./keys/{signer}_private_key.pem", "rb") as f:
    key = DSA.import_key(f.read())

# Load the public key from the file
with open(f"./keys/Dung_public_key.pem", "rb") as f:
    pub_key = DSA.import_key(f.read())

# Create a message to sign
message = b"Hello, World!"

# Generate the signature
hash = SHA256.new(message)
signer = DSS.new(key, "fips-186-3")
signature = signer.sign(hash)

# Verify the signature
hash = SHA256.new(message)
verifier = DSS.new(pub_key, "fips-186-3")
try:
    verifier.verify(hash, signature)
    print("Signature is valid")
except ValueError:
    print("Signature is invalid")
