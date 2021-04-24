# -*- coding: utf-8 -*-

import re
from xkeysnail.transform import *


define_multipurpose_modmap(
    {
    Key.CAPSLOCK: [Key.ESC, Key.LEFT_CTRL],
    Key.MUHENKAN: [Key.MUHENKAN, Key.LEFT_CTRL],
    Key.HENKAN: [Key.HENKAN, Key.RIGHT_CTRL]
    }

)

# define_keymap(condition, mapping, name)

define_keymap(
    None,
    {
        K('esc'): [K('muhenkan'), K('esc')],
        K('C-a'): with_mark(K('Home')),
        K('C-e'): with_mark(K('End'))
    },"Always"
)
