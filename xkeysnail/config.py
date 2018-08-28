# -*- coding: utf-8 -*-

import re
from xkeysnail.transform import *

define_multipurpose_modmap(
    # Capslock is escape when pressed and released. Control when held down.
    {
        Key.CAPSLOCK: [Key.ESC, Key.LEFT_CTRL]
    }, "CapsLock as ESC when pressed, Ctrl when held"

)

define_keymap(
    re.compile('Tilix'), {
        K('esc'): [K('muhenkan'), K('esc')]
    }, "Esc and IME off"
)
