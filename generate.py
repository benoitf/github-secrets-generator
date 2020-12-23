from base64 import b64encode
from nacl import encoding, public
import json
import sys

key = sys.argv[1]
# first secret could be a login
firstSecret = sys.argv[2]
# second secret could be a password, ot omitted if only using a key/token
secondSecret = sys.argv[3]

def encrypt(public_key: str, secret_value: str) -> str:
    """Encrypt a Unicode string using the public key."""
    public_key = public.PublicKey(public_key.encode("utf-8"), encoding.Base64Encoder())
    sealed_box = public.SealedBox(public_key)
    encrypted = sealed_box.encrypt(secret_value.encode("utf-8"))
    return b64encode(encrypted).decode("utf-8")

encodedfirstSecret = encrypt(key, firstSecret)
if secondSecret:
  result = {
    "firstSecret": encodedfirstSecret,
    "secondSecret": encrypt(key, secondSecret)
  }
else:
  result = {
    "firstSecret": encodedfirstSecret
  }

jsonStr = json.dumps(result, indent=2)
print(jsonStr)
