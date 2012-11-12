require "spec_helper"

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

  it "can send a single file" do
    ftp = FtpNetwork.new(cred, "/public_html")
    `touch example`
    ftp.send(["example"])
    ftp.list.each do |file|
      puts file
    end
  end

  it "what about when sending an entirely new dir?" do
    pending "Looks like we have to detect that condition and create them"
  end
end
