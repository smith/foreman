require "spec_helper"
require "foreman/engine"
require "foreman/export/supervisor"
require "tmpdir"

describe Foreman::Export::Supervisor do
  let(:procfile) { FileUtils.mkdir_p("/tmp/app"); write_procfile("/tmp/app/Procfile") }
  let(:engine) { Foreman::Engine.new(procfile) }
  let(:supervisor) { Foreman::Export::Supervisor.new(engine) }

  before(:each) { load_export_templates_into_fakefs("supervisor") }
  before(:each) { stub(supervisor).say }

  it "exports to the filesystem" do
    supervisor.export("/tmp/init")

    #File.read("/tmp/init/app.conf").should         == example_export_file("supervisor/app.conf")
    #File.read("/tmp/init/app-alpha.conf").should   == example_export_file("supervisor/app-alpha.conf")
    #File.read("/tmp/init/app-alpha-1.conf").should == example_export_file("supervisor/app-alpha-1.conf")
    #File.read("/tmp/init/app-alpha-2.conf").should == example_export_file("supervisor/app-alpha-2.conf")
    #File.read("/tmp/init/app-bravo.conf").should   == example_export_file("supervisor/app-bravo.conf")
    #File.read("/tmp/init/app-bravo-1.conf").should == example_export_file("supervisor/app-bravo-1.conf")
  end
end
