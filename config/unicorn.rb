# coding: utf-8
# Copyright (c) 2014 Ali Polatel <alip@exherbo.org>
# Licensed under the terms of the GNU General Public License v3 (or later)

CONFDIR = File.expand_path(File.dirname(__FILE__))
WORKDIR = File.expand_path(File.join(CONFDIR, '..'))
LOGDIR  = File.join(WORKDIR, 'log')
TMPDIR  = File.join(WORKDIR, 'tmp')

def count_core
  begin
    c = `getconf _NPROCESSORS_ONLN 2>/dev/null`
    c.chomp.to_i
  rescue
    c = 1
  end
end

working_directory WORKDIR + File::SEPARATOR
pid File.join(TMPDIR, "pids", "unicorn.pid")

case ENV['RACK_ENV']
when /production/
  worker_processes count_core
  listen File.join(TMPDIR, "sockets", "unicorn.sock"), :backlog => 64
  stdout_path File.join(LOGDIR, 'unicorn-stdout.log')
  stderr_path File.join(LOGDIR, 'unicorn-stderr.log')
else
  worker_processes 1
  listen 4567, :tcp_nopush => true
end
