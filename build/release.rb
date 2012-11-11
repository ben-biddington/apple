class Release
  def initialize(version_control,network)
    @version_control = version_control
    @network = network
  end
  
  def deploy
    changes = @version_control.changes
    
    @network.send changes.modified
    @network.delete changes.deleted
  end
end
