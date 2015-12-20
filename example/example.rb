require 'conoha_api'

client = ConohaApi::Client.new(
  login: '',
  password: '',
  tenant_id: '',
  api_endpoint: 'https://identity.tyo1.conoha.io/v2.0'
)

# gather infomations to create server
key = client.keypairs.keypairs.first
flavor = client.flavors.flavors.first
image = client.images.images.first

# create new server
puts client.add_server(image.id, flavor.id, key_name: key.keypair.name)

# force stop all servers
client.servers.servers.each do |server|
  puts client.force_stop_server(server.id)
end

# delete all servers
client.servers.servers.each do |server|
  puts client.delete_server(server.id)
end
