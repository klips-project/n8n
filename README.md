# n8n

This repository holds docker and n8n [n8n-io/n8n](https://github.com/n8n-io/n8n) configuration files in order to model and handle project specific workflows.

You will need to create a `.env` file in the `docker` folder with the following content:

```text
POSTGRES_PASSWORD=🔑
```

The password needs to be changed of course.

After starting up the `docker-compose.yml` file in `./docker` via `docker-compose up`, open the UI on [localhost:5678](http://localhost:5678/). Create the RabbitMQ credentials and import the workflows from the workflows folder.
