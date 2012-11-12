class RemoteVersion
  def initialize(network)
    @network = network
  end

  def set
    version = `git log -n 1 --pretty="%H"`
    
    `echo "#{version}" > VERSION`

    @network.send(["VERSION"])
  end
end
