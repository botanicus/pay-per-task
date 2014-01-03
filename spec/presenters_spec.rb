require 'spec_helper'
require 'ppt/presenters'

describe PPT::Presenters::User do
  let(:valid_values) {{
    service: 'pt',
    username: 'botanicus',
    email: 'james@101ideas.cz',
    accounting_email: 'accounting@101ideas.cz'
  }}

  describe ".new(values)" do
    it "takes following properties: service, username, email and accounting_email" do
      expect {
        described_class.new(valid_values)
        }.not_to raise_error
    end
  end

  describe "accessors" do
    subject { described_class.new(valid_values) }

    context "valid" do
      it "allows you to read service" do
        subject.should respond_to(:service)
        subject.service.should eql('pt')
      end

      it "allows you to read username" do
        subject.should respond_to(:username)
        subject.username.should eql('botanicus')
      end

      it "allows you to read email" do
        subject.should respond_to(:email)
        subject.email.should eql('james@101ideas.cz')
      end

      it "allows you to read accounting_email" do
        subject.should respond_to(:accounting_email)
        subject.accounting_email.should eql('accounting@101ideas.cz')
      end
    end

    context "invalid" do
      it "raises NoMethodError if you try to read non-existing property" do
        subject.should_not respond_to(:juiciness)
        expect { subject.juiciness }.to raise_error(NoMethodError)
      end
    end
  end
end
