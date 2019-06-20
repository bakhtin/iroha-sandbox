The code snippet below creates a connection object, configures private key of user Alice and sets up helper methods to allow tracing of each stage the transaction passes in Iroha. The snippet can be directly copied to a text editor right next to it. It is automatically saved and can be modified if you feel it.

<pre class="file" data-filename="client.py" data-target="replace">
#!/usr/bin/env python3.7

import iroha, binascii
from iroha import Iroha, IrohaGrpc, IrohaCrypto
from iroha.primitive_pb2 import *

iroha = Iroha('alice@test')
net = IrohaGrpc()
alice_private_key = '2d8cd91d3939420e7be09a54fb24d592b28c94de712cc7b2344d14b5471d889a'

def trace(func):
  """
  A decorator for tracing methods' begin/end execution points
  """
  def tracer(*args, **kwargs):
    name = func.__name__
    print('\tEntering "{}"'.format(name))
    result = func(*args, **kwargs)
    print('\tLeaving "{}"'.format(name))
    return result
  return tracer

@trace
def send_transaction_and_print_status(transaction):
  hex_hash = binascii.hexlify(IrohaCrypto.hash(transaction))
  print('Transaction hash = {}, creator = {}'.format(
      hex_hash, transaction.payload.reduced_payload.creator_account_id))
  net.send_tx(transaction)
  for status in net.tx_status_stream(transaction):
    print(status)
</pre>


This snippet defines a list of commands that will be wrapped into a transaction and sent to Iroha. We execute `AddAssetQuantity` command that adds up a certain amount to the asset. Full list of commands and queries can be found in [Iroha docs](https://iroha.readthedocs.io/en/latest/api/index.html). 

Alice has a permission called `can_add_asset_qty` that allows to issue an asset quantity (basically, creating money out of the air).

<pre class="file" data-filename="add-asset-quantity.py" data-target="replace">
#!/usr/bin/env python3.7

import client

@client.trace
def send():  
  commands = [    
    client.iroha.command('AddAssetQuantity', asset_id='coin#test', amount='50000.00')
  ]
  tx = client.iroha.transaction(commands, quorum=1)
  client.IrohaCrypto.sign_transaction(tx, client.alice_private_key)
  client.send_transaction_and_print_status(tx)

send()
</pre>

The script can now be executed:

`python3.7 add-asset-quantity.py`{{execute}}

You should see several statuses returned during the script execution followed by terminal status `COMMITTED`. Transaction is now committed to a block store. It can be verified by looking up its contents:

`docker exec iroha cat /tmp/block_store/0000000000000002 | python3 -m json.tool`{{execute}}