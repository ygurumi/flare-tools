# -*- coding: utf-8; -*-
# Authors::   Kiyoshi Ikehara <kiyoshi.ikehara@gree.co.jp>
# Copyright:: Copyright (C) Gree,Inc. 2011. All Rights Reserved.
# License::   NOTYET

require 'flare/tools/stats'
require 'flare/tools/node'
require 'flare/tools/index_server'
require 'flare/tools/common'
require 'flare/util/conversion'
require 'flare/util/constant'
require 'flare/tools/cli/sub_command'

module Flare
  module Tools
    module Cli
      
      class Activate < SubCommand
        include Flare::Util::Conversion
        include Flare::Util::Constant
        include Flare::Tools::Common
        
        myname :activate
        desc   "activate "
        usage  "down [hostname:port] ..."
        
        def setup(opt)
          opt.on('--force',            "commits changes without confirmation") {@force = true}
        end

        def initialize
          super
          @force = false
        end

        def execute(config, *args)
          return S_NG if args.size < 1

          hosts = args.map {|x| x.split(':')}
          hosts.each do |x|
            if x.size != 2
              puts "invalid argument '#{x.join(':')}'."
              return S_NG
            end
          end
          
          Flare::Tools::IndexServer.open(config[:index_server_hostname], config[:index_server_port], config[:timeout]) do |s|
            nodes = s.stats_nodes.sort_by{|key, val| [val['partition'], val['role'], key]}
          
            hosts.each do |hostname,port|
              hostname_port = "#{hostname}:#{port}"
              port = if port.nil? then DefaultNodePort else port.to_i end
              ipaddr = address_of_hostname(hostname)
          
              unless node = nodes.inject(false) {|r,i| if i[0] == hostname_port then i[1] else r end}
                error "invalid 'hostname:port' pair: #{hostname_port}"
                return S_NG
              end

              exec = @force
              if exec
              elsif node['state'] == 'active'
                puts "#{ipaddr}:#{port} is already active."
              else
                print "turning node up (node=#{ipaddr}:#{port}, state=#{node['state']} -> activate) (y/n): "
                interruptible do
                  exec = true if gets.chomp.upcase == "Y"
                end
              end
              if exec
                s.set_state(hostname, port, 'active') unless config[:dry_run]
              end
            end

            puts string_of_nodelist(s.stats_nodes, hosts.map {|x| "#{x[0]}:#{x[1]}"})
          end
          
          S_OK
        end # execute()
        
        def stat_one_node(s)
          
        end

      end
    end
  end
end