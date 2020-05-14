# PureBasicRAT
<p>
<h4>A Remote Administration Tool for windows, built using PureBasic</h4>
Uses the Telegram Bot API as the communication channel to the server<br>
Create a bot of your own by consulting @BotFather and use the bot token in the builder.<br> 
You also need to provide your user id which you can get by consulting @useridbot or the like.
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
<h4><li>/keypress</li></h4>
<p>
Simulate a series of keystrokes. Must be in the form:
  
```
/keypress Something to type here
```
  
</p>
<h4><li>/lclick</li></h4>
<p>
Simulate left mouse button click. Must be in the form:
  
```
/lclick <repetitions> <interval between subsequent clicks in milliseconds>
```
  
</p>
<h4><li>/rclick</li></h4>
<p>
Simulate right mouse button click. Must be in the form:
  
```
/rclick <repetitions> <interval between subsequent clicks in milliseconds>
```
  
</p>
<h4><li>/mclick</li></h4>
<p>
Simulate middle mouse button click. Must be in the form:
  
```
/mclick <repetitions> <interval between subsequent clicks in milliseconds>
```
  
</p>
</ol>

<p>


>Prepend a machine ID for targetted command. E.g:

```
<ID>/command
```

</p>
