$LOAD_PATH.unshift(File.expand_path('../../../lib', __FILE__))

require 'ppt/spec_helper'

PPT::SpecHelper.enforce_vagrant
PPT::SpecHelper.configure('s:inbox.pt')
