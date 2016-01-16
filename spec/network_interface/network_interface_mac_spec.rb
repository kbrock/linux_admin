describe LinuxAdmin::NetworkInterfaceMac do
  it "raises exception if none found" do
    expect(Socket).to receive(:ip_address_list).and_return([])
    expect { described_class.new("eth0") }.to raise_error(LinuxAdmin::NetworkInterfaceError)
  end

  it "returns the ip of the first ipv4 non loopback device" do
    allow(Socket).to receive(:ip_address_list).and_return([
      double(:ipv4? => false, :ipv4_loopback? => false, :ip_address => "::1"),
      double(:ipv4? => true,  :ipv4_loopback? => true,  :ip_address => "127.0.0.1"),
      double(:ipv4? => true,  :ipv4_loopback? => false, :ip_address => "192.168.10.10"),
    ])
    ip = described_class.new("eth0")
    expect(ip.ip_show).to eq("192.168.10.10")
  end
end
