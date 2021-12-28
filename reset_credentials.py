#!/usr/bin/env python3

import keyring

keyring.set_password(
    'FastMail FTP',
    'rahul@sent.com',
    input('FastMail FTP password: '))

