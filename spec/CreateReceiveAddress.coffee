noflo = require 'noflo'
chai = require 'chai' unless chai
uuid = require 'uuid'
CreateReceiveAddress = require '../components/CreateReceiveAddress.coffee'

describe 'CreateReceiveAddress component', ->
  c = CreateReceiveAddress.getComponent()
  wallet = noflo.internalSocket.createSocket()
  callback = noflo.internalSocket.createSocket()
  address = noflo.internalSocket.createSocket()
  error = noflo.internalSocket.createSocket()
  c.inPorts.wallet.attach wallet
  c.inPorts.callback.attach callback
  c.outPorts.address.attach address
  c.outPorts.error.attach error

  describe 'requesting a new receive address', ->
    it 'should return a wallet address corresponding to the callback URL', (done) ->
      cbURL = "http://foo.com/bar/baz?one=two&id=#{uuid.v4()}"
      gotURL = false

      address.on 'begingroup', (group) ->
        chai.expect(group).to.equal cbURL
        gotURL = true
      address.on 'data', (data) ->
        chai.expect(data).to.be.a 'string'
        chai.expect(gotURL).to.be.true
        done()

      error.on 'data', (data) ->
        console.log data
        done data

      wallet.send '1CoEP9bVEoNogSnpSAhQNHVHBfUUyFyt1W'
      callback.send cbURL
      wallet.disconnect()
      callback.disconnect()
