The sandbox runs Iroha v1.0 pre-configured with two users: `alice@test` and `bob@test`. Both having [all available permissions](https://github.com/hyperledger/iroha/blob/master/shared_model/schema/primitive.proto#L29) in the system. There is also an asset -- `coin#test`.

There is [Python Iroha library](https://github.com/hyperledger/iroha-python/) installed in the system.

Check that Iroha is up and running:
`docker-compose -f /opt/sandbox/docker-compose.yml ps`{{execute}}

We run a [dockerized version of Iroha](https://hub.docker.com/r/hyperledger/iroha/). The container should show up as `UP` in the command output.

All set. We can proceed with actual interaction with Iroha API