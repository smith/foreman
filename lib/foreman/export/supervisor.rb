require "erb"
require "foreman/export"

class Foreman::Export::Supervisor < Foreman::Export::Base

  def export(location="/etc/supervisor/conf.d", options={})
    FileUtils.mkdir_p location
    app = options[:app] || File.basename(engine.directory)
    processes = engine.processes.values

    # App group
    programs  = processes.map {|v| "#{app}-#{v.name}" }.join(",")
    group_template = export_template("supervisor/group.conf.erb")
    group_config   = ERB.new(group_template).result(binding)
    write_file "#{location}/#{app}.conf", group_config

    # Individual programs
    user = options[:user] || app
    log_root = options[:log]
    program_template = export_template("supervisor/program.conf.erb")
    concurrency = Foreman::Utils.parse_concurrency(options[:concurrency])

    processes.each do |program|
      num_procs = concurrency[program.name] || 1
      program_config = ERB.new(program_template, nil, "<>").result(binding)
      write_file "#{location}/#{app}-#{program.name}.conf", program_config
    end

    ctl "update"
  end

private ######################################################################

  # Shortcut to run supervisorctl
  def ctl(cmd="")
    system("supervisorctl #{cmd}") unless cmd.empty?
  end
end
