<h1 align="center">
Theme Preview
</h1>

## minimalsys

![minimalsys](https://github.com/imegeek/myconfigs/assets/63346676/945463a6-edbc-4b97-bf53-1fd22d378aba)
[download  - minimalsys](https://github.com/imegeek/myconfigs/files/15441285/minimalsys.omp.json)

## minimalsys2

![minimalsys2](https://github.com/imegeek/myconfigs/assets/63346676/60d5325c-1eef-4919-9ff3-3f1bd21c4f6b)
[download - minimalsys2](https://github.com/imegeek/myconfigs/files/15441286/minimalsys2.omp.json)

## minimalsys3

![minimalsys3](https://github.com/imegeek/myconfigs/assets/63346676/72e751de-0320-4f1a-b8db-0bced511028d)
[download - minimalsys3](https://github.com/imegeek/myconfigs/files/15441287/minimalsys3.omp.json)

## How to Apply Theme

1. Open File Explorer and goto `C:\Users\%USERNAME%\AppData\Local\Programs\oh-my-posh\themes` directory then place theme files here.
2. Update PowerShell Profile:

- Open Terminal and run command `notepad $profile`
- Paste this code in opened notepad, replace "theme_name_here" with exact theme name that you want to apply and save.

```
$THEME = "theme_name_here"

oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/$THEME.omp.json" | Invoke-Expression
```
