# PureBasicRAT
<p>
A Remote Administration Tool for windows, built using PureBasic.<br>Uses the Telegram Bot API as the communication channel to the server
</p>
<p>
Currently, it supports the following commands:
<ol>
<h4><li>/info</li></h4>
<p>
Retrieves basic information about the host machine.
</p>
<h4><li>/sreenshot</li></h4>
<p>
Retrieves the screenshot of the host machine.
</p>
<h4><li>/getkeylog</li></h4>
<p>
Retrieves the keystrokes recorded on the host machine.
</p>
<h4><li>/msgbox</li></h4>
<p>
Displays a messagebox on the host machine. Must be in the form:

```
/msgbox Title;;Message
```

</p>
<h4><li>/blockinput</li></h4>
<p>
Blocks keyboard and mouse inputs for a maximum of 60 seconds on the host machine.
</p>
</p>
<h4><li>/unblockinput</li></h4>
<p>
No points for guessing.
</p>
</ol>

<p>


>Prepend a machine ID for targetted command. E.g:

```
<ID>/command
```

</p>
