class YamlFtpCredential
  def initialize(file)
    fail "File missing <#{file}>" unless File.exists? file
    require 'yaml'
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

  def send(files=[])
    Net::FTP.open(@ftp_credential.host,@ftp_credential.username, @ftp_credential.password) do |ftp|
      files.each do |file|
        ftp.putbinaryfile file,"#{@remote_dir}/#{file}"
      end
    end
  end
end
