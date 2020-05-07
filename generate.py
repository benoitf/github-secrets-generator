from base64 import b64encode
from nacl import encoding, public
import json
import sys

key = sys.argv[1]
login = sys.argv[2]
password = sys.argv[3]

def encrypt(public_key: str, secret_value: str) -> str:
    """Encrypt a Unicode string using the public key."""
    public_key = public.PublicKey(public_key.encode("utf-8"), encoding.Base64Encoder())
    sealed_box = public.SealedBox(public_key)
    encrypted = sealed_box.encrypt(secret_value.encode("utf-8"))
    return b64encode(encrypted).decode("utf-8")

encodedLogin = encrypt(key, login)
encodedPassword = encrypt(key, password)

result = {
  "login": encodedLogin,
  "password": encodedPassword
}

jsonStr = json.dumps(result, indent=2)
print(jsonStr)
