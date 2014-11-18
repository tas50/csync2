require 'spec_helper'

describe package('csync2') do
  it { should be_installed }
end
