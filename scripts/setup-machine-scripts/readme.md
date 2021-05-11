# Machine Setup Scripts

Scripts to speed up setting up a new debian based machine.

---

## Introduction

This will make a setup script that includes your ssh keys and asks you to protect them before they are added. This is to make sure that if the script is compromised, there will be a layer of protection on them.

** Includes **

- vim for python, json and yaml files
- tmux
- htop, ncdu
- nvm (Node version manager)
- curl

## Usage

To create a install script:

```
bash make_script.sh
```

This will create an `install.sh` script that you can put somewhere:

```
curl -L https://mywebservice.com/install.sh | bash
```


To remove the password protection on the keys after you've installed them:

```
ssk-keygen -p
```
