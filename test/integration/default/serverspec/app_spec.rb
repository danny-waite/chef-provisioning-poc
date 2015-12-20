require 'spec_helper'

describe process("app") do
  it { should be_running }
end

describe port(8484) do
  it { should be_listening }
end