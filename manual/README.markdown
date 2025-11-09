# Manual preference adjustments

This file captures settings/changes that I make that I haven't yet figured out
how to conveniently keep synced or just haven't put in the work yet.

## Firefox

find or create `user.js` in your profile folder in `~/.mozilla/firefox/`, add:

```
user_pref("browser.ml.enable", false);
user_pref("browser.ml.chat.enabled", false);
user_pref("browser.ml.chat.hideFromLabs", true);
user_pref("browser.ml.chat.hideLabsShortcuts", true);
user_pref("browser.ml.chat.page", false);
user_pref("browser.ml.chat.page.footerBadge", false);
user_pref("browser.ml.chat.page.menuBadge", false);
user_pref("browser.ml.chat.menu", false);
user_pref("browser.ml.linkPreview.enabled", false);
user_pref("browser.ml.pageAssist.enabled", false);
user_pref("browser.tabs.groups.smart.enabled", false);
user_pref("browser.tabs.groups.smart.userEnable", false);
user_pref("extensions.ml.enabled", false);
```

### Tridactyl

https://github.com/tridactyl/tridactyl

The native messenger's AUR package (firefox-tridactyl-native) should have gotten
installed. With that & the firefox extension installed, the checked-in
`tridactylrc` config should be used.
