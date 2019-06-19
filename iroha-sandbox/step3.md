<pre class="file" data-filename="get-account-assets.py" data-target="replace">
#!/usr/bin/env python3.7

import client

@client.trace
def send():
  query = client.iroha.query('GetAccountAssets', account_id='bob@test')
  client.IrohaCrypto.sign_query(query, client.alice_private_key)
  response = client.net.send_query(query)
  data = response.account_assets_response.account_assets
  for asset in data:
    print('Asset id = {}, balance = {}'.format(
      asset.asset_id, asset.balance))

send()
</pre>

`python3.7 get-account-assets.py`{{execute}}