module Tika
  RSpec.describe Request do

    subject { described_class.new(connection, options) }
    let(:connection) { Net::HTTP.new("localhost", 9998) }
    
    

  end
end
