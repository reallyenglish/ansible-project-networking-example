require 'spec_helper'

describe server(:client_jp) do
  describe firewall(server(:gw_jp)) do
    it { is_expected.to be_reachable }
  end

  describe firewall(server(:gw_uk)) do
    it { is_expected.not_to be_reachable }
  end
end
