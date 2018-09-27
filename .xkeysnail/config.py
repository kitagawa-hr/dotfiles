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

define_keymap(
    re.compile("Google-chrome"), {
    K("C-k"): with_mark(K("C-TAB")),
    K("C-j"): with_mark(K("C-Shift-TAB")),
    K("C-b"): with_mark(K("M-Left")),
    K("C-f"): with_mark(K("M-Right")),
}, "Vim on Chrome")
