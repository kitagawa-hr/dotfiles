# -*- coding: utf-8 -*-

import re
from xkeysnail.transform import define_multipurpose_modmap, define_keymap, Key, K


define_multipurpose_modmap(
    {
    Key.CAPSLOCK: [Key.ESC, Key.LEFT_CTRL],
    Key.MUHENKAN: [Key.MUHENKAN, Key.LEFT_ALT],
    Key.HENKAN: [Key.HENKAN, Key.RIGHT_CTRL]
    }

)

# define_keymap(condition, mapping, name)

define_keymap(
    None,
    {
        K('esc'): [K('muhenkan'), K('esc')]
    },"IME off when Escaped"
)

define_keymap(
    re.compile("Firefox|Google-chrome"), {
    K("K"): K("C-TAB"),
    K("J"): K("C-Shift-TAB"),
}, "Vim on Chrome")
