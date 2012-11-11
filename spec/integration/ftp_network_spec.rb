require "spec_helper"

class YamlFtpCredential
  def initialize(file)
    fail "File missing <#{file}>" unless File.exists? file
    
    @yaml = YAML.load(File.read(file))
  end

  def host;     @yaml["host"];     end
  def username; @yaml["username"]; end
  def password; @yaml["password"]; end
end

class FtpNetwork
  require "net/ftp"

  def initialize(ftp_credential, remote_dir)
    @ftp_credential, @remote_dir = ftp_credential, remote_dir
  end
  
  def list
    Net::FTP.open(@ftp_credential.host,@ftp_credential.username, @ftp_credential.password) do |ftp|
      files = ftp.chdir(@remote_dir)
      return ftp.list
    end
  end
end

describe FtpNetwork do
  let(:cred) { 
    config_file = File.join(File.dirname(__FILE__), ".ftp")
    fail "This test requires a config file containing the ftp details to be present at <#{config_file}>" unless File.exists?(config_file)
    YamlFtpCredential.new config_file
  }

  it "can list files" do
    ftp = FtpNetwork.new(cred, "/public_html")
    ftp.list[0].should match /drwxr-x---/
  end
end
