
## my_dotfiles

# Content

## Emacs


The main feature of this repository is the included Emacs configuration.
Despite be a quite good editor, GNU-Emacs comes with its own scripting langage, `elisp`, allowing for some kind of 'auto-setup' at first launch. (and other fancy stuff).

The OS requirement are light:

- Fira code symbol. Grab it [here](https://github.com/tonsky/FiraCode/files/412440/FiraCode-Regular-Symbol.zip). _Many thanks to github user alphapapa_.
  On Linux, you'll have to put it into your `~/.local/share/fonts/` and maybe rebuild the font cache after that.


You can use the whole Fira Code font (use your package manager or grab it [there](https://github.com/tonsky/FiraCode)), otherwise, this configuration does not enforce any font. _Fira Code Symbol_ is only used for programming ligatures.
Of course, you can get rid of this by commenting out some _elisp_.

### First start

- Copy `emacs_config.el` to `~/.emacs`. Do not forget to backup your previous `~/.emacs`.
- run `emacs` somewhere in a terminal. emacs will start to execute its configuration.
  During the process, it may ask your a few question. If you don't understand the meaning, type yes (`y`).


After a few blinks, it should be ready. You should see a buffer containing compilation logs, just close it (`C-x-k RET`).

Considering a daily use, I suggest to use [emacsclient](https://www.emacswiki.org/emacs/EmacsClient#toc4), which is part of emacs:
```
$ emacsclient -create-frame --alternate-editor=""
```

### includes:

- programming ligatures
- edit/read files within docker container using tramp, ie: `C-x-f /docker:` `↹` to complete.
- major modes for Python, PHP, Javascript, Vue sources, markdown, rust ... many
- see your project's tree using `C-c x` (direct). dedicate and freeze windows using `M-x dedicate-window` if you like a more IDE-oriented environment.
- `multiple cursors` - look for "multiple cursors" into emacs_config.
- `prettify-symbols` for a constant and highly customisable eye-candy experience
- and more
