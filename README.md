# n8n

This repository holds docker and n8n (https://github.com/n8n-io/n8n) configuration files in order to model and handle project specific workflows.

You will need to create a `.env` file in this folder with the following content:

```
POSTGRES_PASSWORD=SECRET
```

The password needs to be changed of course


After starting up, open the UI on localhost:5678 and create a new set of credentials for rabbit-mq.

Finally, import the workflows from the `workflows` folder.
