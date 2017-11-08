# deployer

Apply any terraform resource by mounting them to `/usr/local/deployer/inputs/`, it also look for changes in `*.tf` and `*.tf.json` files, it applies them automatically.


# Requirements

 - etcd v3
 - Docker
 - Kubernetes (optional)


# Demo

To apply ./inputs/example.tf.json, for more details look in the docker-compose.yaml

    $ docker-compose up --build


# Env variables

 - EXIT_ON_ERROR: set to exit on apply error, otherwise it will retry until success

For examples look into docker-compose.yaml


# Kubernetes

This is sutable for configMaps volumes.

Example of configMap:

    {
      "mysql": {
        "apiVersion": "v1",
        "kind": "ConfigMap",
        "data": {
          "main.tf.json": "{\"provider\":{\"mysql\":{\"endpoint\":\"mysql:3306\",\"password\":\"example\",\"username\":\"root\"}},\"resource\":{\"mysql_database\":{\"database1\":{\"lifecycle\":{\"prevent_destroy\":true},\"name\":\"database1\"}}},\"terraform\":{\"backend\":{\"etcdv3\":{\"endpoints\":[\"http://etcd:2379\"],\"prefix\":\"terraform-tfstate/\"}}}}"
        },
        "metadata": {
          "name": "mysql",
          "namespace": "default"
        }
      }
    }
