# Generates a PBKDF2 hash for qBittorrent WebUI password.
# This is useful for setting the password in the config file.
#
# NOTE: Hashing algorithm must match
# https://github.com/qbittorrent/qBittorrent/blob/master/src/base/utils/password.cpp
#
# Usage: python qbittorrent_hash.py
#
# Author: Beau Hastings (https://github.com/hastinbe)
# Date: 2024-01-09
# License: GPLv2

import hashlib
import os
import sys
import base64


def generate_qbittorrent_hash():
    # Prompt user for password
    password = sys.argv[1]

    # Generate a random salt
    salt = os.urandom(16)
    iterations = 100000  # Number of iterations
    algorithm = 'sha512'  # Hashing algorithm

    # Generate PBKDF2 hash
    dk = hashlib.pbkdf2_hmac(algorithm, password.encode(), salt, iterations)

    # Base64 encode the salt and hash
    encoded_salt = base64.b64encode(salt).decode()
    encoded_hash = base64.b64encode(dk).decode()

    # Format for qBittorrent
    qbittorrent_hash = f'@ByteArray({encoded_salt}:{encoded_hash})'

    return qbittorrent_hash


# Print the result
print(f'{generate_qbittorrent_hash()}')
