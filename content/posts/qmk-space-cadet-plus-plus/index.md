---
title: "qmk space cadet plus"
date: 2022-11-05T09:00:56+02:00
---
I enjoy the space cadet feature of [QMK](https://docs.qmk.fm/) :

https://docs.qmk.fm/#/feature_space_cadet

The feature is simple but yet powerful, when you hit one press you send a
parenthese open or close form the other side and if you hold it you have shift.

I am not sure what happened to my config, but I could not get it to work with
the default macros offered `SC_LSPO` and `SC_RSPO`.

I dug into the `process_record_user()` function hook to replicate the feature and
add one other 'thing' where if you press another shift at the same time of the
keypress it will do a right bracket.

For example, right shift held and left shift will print `{` and left shift held
with right shift will print me `}`.

At the same time i have a
[combo](https://docs.qmk.fm/?ref=blog.splitkb.com#/feature_combo) setup when I
press both shifts quickly, it will print me both `()`.

The code to add in `process_record_user` is this:

```c
#define SC_LSFT OSM(MOD_LSFT)
#define SC_RSFT OSM(MOD_RSFT)

bool process_record_user(uint16_t keycode, keyrecord_t *record) {
    bool ls = (get_mods() | get_weak_mods()) & MOD_BIT(KC_LSFT);
    bool rs = (get_mods() | get_weak_mods()) & MOD_BIT(KC_RSFT);

    switch (keycode) {
        case SC_LSFT:
            if (record->tap.count && rs && record->event.pressed) {
                unregister_code(KC_RSFT);
                tap_code16(KC_LCBR);
                return false;
            } else if (record->tap.count && record->event.pressed) {
                tap_code16(KC_LPRN);
                return false; // Return false to ignore further processing of key
            }
            return true;
        case SC_RSFT:
            if (record->tap.count == 1 && ls) {
                unregister_code(KC_LSFT);
                tap_code16(KC_RCBR);
                return false;
            } else if (record->tap.count == 1 && record->event.pressed) {
                tap_code16(KC_RPRN);
                return false; // Return false to ignore further processing of key
            }
            return true;
    }
}
```
now the hard part is to get used to it and effectively used it :)
