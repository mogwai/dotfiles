with open("./template_script.sh") as f:
    tool_script = f.read()

with open("ssh/id_rsa") as f:
    ssh_key = f.read()

with open("ssh/id_rsa.pub") as f:
    ssh_key_pub = f.read()

tool_script = tool_script.replace("'$SSH_KEY'", ssh_key)
tool_script = tool_script.replace("'$SSH_KEY_PUB'", ssh_key_pub)

print(tool_script)
