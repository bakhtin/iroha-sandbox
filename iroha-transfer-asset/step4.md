The script can now be executed:

`python3.7 add-asset-quantity.py`{{execute}}

You should see several statuses returned during the script execution followed by terminal status `COMMITTED`. Transaction is now committed to a block store. It can be verified by looking up its contents:

`docker exec iroha cat /tmp/block_store/0000000000000002 | python3 -m json.tool`{{execute}}
